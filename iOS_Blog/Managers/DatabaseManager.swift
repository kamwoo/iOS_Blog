//
//  DatabaseManager.swift
//  iOS_Blog
//
//  Created by wooyeong kam on 2021/11/10.
//

import Foundation
import FirebaseFirestore

class DatabaseManager {
    static let shared = DatabaseManager()
    
    private let database = Firestore.firestore()
    
    private init() {}
    
    func insertUser(user: User, completion: @escaping (Bool) -> Void){
        let documentId = user.email
            .replacingOccurrences(of: ".", with: "-")
            .replacingOccurrences(of: "@", with: "-")
        
        let data = [
            "email": user.email,
            "name": user.name
        ]
        database
            .collection("users")
            .document(documentId)
            .setData(data) { error in
                completion(error == nil)
            }
    }
    
    func getUserData(email: String ,completion: @escaping (User?) -> Void){
        let documentId = email
            .replacingOccurrences(of: ".", with: "-")
            .replacingOccurrences(of: "@", with: "-")
        
        database
            .collection("users")
            .document(documentId)
            .getDocument{ snapshot, error in
                guard let data = snapshot?.data() as? [String: String],
                      let name = data["name"],
                    error == nil else {
                    completion(nil)
                    return
                }
                let ref = data["profile_image"]
                let user = User(name: name, email: email, profilePictureURL: ref)
                completion(user)
            }
    }
    
    func updateProfileData(email: String, completion: @escaping (Bool) -> Void){
        let path = email
            .replacingOccurrences(of: "@", with: "-")
            .replacingOccurrences(of: ".", with: "-")
        let ref = "profile_images/\(path)/photo.png"
        let dbRef = database
            .collection("users")
            .document(path)
        
        dbRef.getDocument{ snapshot, error in
            guard var data = snapshot?.data() ,error == nil else { return }
            data["profile_image"] = ref
            dbRef.setData(data){ error in
                    completion(error == nil)
            }
            
        }
        
    }
    
    func insert(blogpost: BlogPost, email: String, completion: @escaping (Bool) -> Void){
        let userEmail = email
            .replacingOccurrences(of: ".", with: "-")
            .replacingOccurrences(of: "@", with: "-")
        
        let data : [String: Any] = [
            "id": blogpost.identifier,
            "title": blogpost.title,
            "body": blogpost.text,
            "created": blogpost.timestamp,
            "headerImageUrl": blogpost.headerImageUrl?.absoluteString ?? ""
        ]
        database
            .collection("users")
            .document(userEmail)
            .collection("posts")
            .document(blogpost.identifier)
            .setData(data){error in
                completion(error == nil)
            }
    }
    
    func getAllPost(completion: @escaping ([BlogPost]) -> Void){
        // get all users
        database
            .collection("users")
            .getDocuments{[weak self] snapshot, error in
                guard let documents = snapshot?.documents.compactMap({$0.data()}),
                      error == nil else {
                    return
                }
                let emails:[String] = documents.compactMap({ $0["email"] as? String})
                guard !emails.isEmpty else { return completion([])}
                
                var result = [BlogPost]()
                
                let group = DispatchGroup()
                for email in emails {
                    group.enter()
                    self?.getPosts(email: email){ posts in
                        defer {
                            group.leave()
                        }
                        result.append(contentsOf: posts)
                    }
                }
                group.notify(queue: .global()){
                    completion(result)
                }
            }
    }
    
    func getPosts(email: String, completion: @escaping ([BlogPost]) -> Void){
        let userEmail = email
            .replacingOccurrences(of: ".", with: "-")
            .replacingOccurrences(of: "@", with: "-")
        
        database
            .collection("users")
            .document(userEmail)
            .collection("posts")
            .getDocuments{ snapshot, error in
                guard let documents = snapshot?.documents.compactMap({$0.data()}),
                      error == nil else {
                    return
                }
                let posts:[BlogPost] = documents.compactMap({ dictionary in
                    guard let id = dictionary["id"] as? String,
                          let title = dictionary["title"] as? String,
                          let body = dictionary["body"] as? String,
                          let created = dictionary["created"] as? TimeInterval,
                          let headerImageUrl = dictionary["headerImageUrl"] as? String else {
                        return nil
                    }
                    let post = BlogPost(identifier: id,
                                        title: title,
                                        timestamp: created,
                                        headerImageUrl: URL(string: headerImageUrl),
                                        text: body)
                    return post
                })
                completion(posts)
            }
    }
    
    
}
