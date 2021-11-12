//
//  StorageManager.swift
//  iOS_Blog
//
//  Created by wooyeong kam on 2021/11/10.
//

import Foundation
import FirebaseStorage

class StorageManager {
    static let shared = StorageManager()
    
    private let container = Storage.storage()
    
    private init(){}
    
    func uploadUserProfilePicture(email: String, image: UIImage?, completion: @escaping (Bool) -> Void){
        let path = email
            .replacingOccurrences(of: "@", with: "-")
            .replacingOccurrences(of: ".", with: "-")
        guard let pngData = image?.pngData() else {
            return
        }
        container
            .reference(withPath: "profile_images/\(path)/photo.png")
            .putData(pngData, metadata: nil){ metaData, error in
                guard error == nil else {
                    completion(false)
                    return
                }
                completion(true)
            }
    }
    
    func downloadUrlForProfilePicture(path: String, completion: @escaping (URL?) -> Void){
        container
            .reference(withPath: path)
            .downloadURL{ url, _ in
                completion(url)
            }
    }
    
    func uploadBlogHeaderImage(email:String,image: UIImage,postId:String, completion: @escaping (Bool) -> Void){
        let path = email
            .replacingOccurrences(of: "@", with: "-")
            .replacingOccurrences(of: ".", with: "-")
        guard let pngData = image.pngData() else {
            return
        }
        container
            .reference(withPath: "post_headers/\(path)/\(postId).png")
            .putData(pngData, metadata: nil){ metaData, error in
                guard error == nil else {
                    completion(false)
                    return
                }
                completion(true)
            }
    }
    
    func downloadUrlForPostHeader(email:String, postId: String, completion: @escaping (URL?) -> Void){
        let emailComponent = email
            .replacingOccurrences(of: "@", with: "-")
            .replacingOccurrences(of: ".", with: "-")
        container
            .reference(withPath: "post_headers/\(emailComponent)/\(postId).png")
            .downloadURL { URL, Error in
                guard Error == nil else {
                    return
                }
                completion(URL)
            }
    }
    
}
