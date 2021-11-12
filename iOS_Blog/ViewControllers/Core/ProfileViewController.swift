//
//  ProfileViewController.swift
//  iOS_Blog
//
//  Created by wooyeong kam on 2021/11/10.
//

import UIKit

class ProfileViewController: UIViewController {

    private let currentEmail: String
    private var name: String?
    
    private var posts = [BlogPost]()
    
    init(currentEmail :String){
        self.currentEmail = currentEmail
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private let tableView: UITableView = {
       let tableView = UITableView()
        tableView.register(PostPreviewTableViewCell.self,
                           forCellReuseIdentifier: PostPreviewTableViewCell.identifer)
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "프로필"
        configSignOutButton()
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        configTableHeader()
        fetchProfileDate()
        fetchPosts()
    }
    private func fetchProfileDate(){
        DatabaseManager.shared.getUserData(email: currentEmail){ [weak self] user in
            guard let user = user else { return }
            self?.name = user.name
            DispatchQueue.main.async {
                self?.configTableHeader(profileImageURL: user.profilePictureURL,
                                        name: user.name)
            }
        }
    }
    
    private func configTableHeader(profileImageURL: String? = nil, name: String? = nil){
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.width, height: view.width))
        headerView.backgroundColor = .systemBackground
        headerView.clipsToBounds = true
        headerView.isUserInteractionEnabled = true
        tableView.tableHeaderView = headerView
        
        let profileImage = UIImageView(image: UIImage(systemName: "person"))
        profileImage.tintColor = .link
        profileImage.contentMode = .scaleAspectFit
        profileImage.isUserInteractionEnabled = true
        let imageSize: CGFloat = view.width/4
        profileImage.frame = CGRect(x: view.width/2 - imageSize/2,
                                    y: (headerView.height - imageSize)/2,
                                    width: imageSize, height: imageSize)
        profileImage.layer.masksToBounds = true
        profileImage.layer.cornerRadius = profileImage.width/2
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapProfileImage))
        profileImage.addGestureRecognizer(gesture)
        
        let emailLabel = UILabel()
        emailLabel.text = currentEmail
        emailLabel.textAlignment = .center
        emailLabel.font = .systemFont(ofSize: 25, weight: .medium)
        emailLabel.sizeToFit()
        emailLabel.frame = CGRect(x: profileImage.center.x - emailLabel.width/2,
                                  y: profileImage.bottom + 10,
                                  width: emailLabel.width,
                                  height: emailLabel.height)
        
        headerView.addSubview(profileImage)
        headerView.addSubview(emailLabel)
        
        if let name = name {
            title = name
        }
        if let ref = profileImageURL {
            StorageManager.shared.downloadUrlForProfilePicture(path: ref){ url in
                guard let url = url else {return}
                URLSession.shared.dataTask(with: url){ data, _, _ in
                    guard let data = data else {return}
                    DispatchQueue.main.async {
                        profileImage.image = UIImage(data: data)
                    }
                }.resume()
            }
        }
    }
    
    @objc private func didTapProfileImage(){
        guard let myEmail = UserDefaults.standard.string(forKey: "email"),
              currentEmail == myEmail else {
            return
        }
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    private func configSignOutButton(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "로그아웃",
                                                            style: .done ,
                                                            target: self,
                                                            action: #selector(didTapLogout))
    }
    
    
    @objc private func didTapLogout(){
        let alert = UIAlertController(title: "로그아웃", message: "로그아웃 하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "확인", style: .destructive){ _ in
            AuthManager.shared.signOut{ [weak self] signOuted in
                if signOuted {
                    UserDefaults.standard.setValue(nil, forKey: "email")
                    UserDefaults.standard.setValue(nil, forKey: "name")
                    DispatchQueue.main.async {
                        let signInVC = SignInViewController()
                        signInVC.navigationItem.largeTitleDisplayMode = .always
                        let nav = UINavigationController(rootViewController: signInVC)
                        nav.navigationBar.prefersLargeTitles = true
                        nav.modalPresentationStyle = .fullScreen
                        self?.present(nav, animated: true, completion: nil)
                    }
                }
            }
        })
        present(alert, animated: true)
    }
    
    private func fetchPosts(){
        DatabaseManager.shared.getPosts(email: currentEmail){[weak self] Posts in
            self?.posts = Posts
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }

}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostPreviewTableViewCell.identifer,
                                                       for: indexPath) as? PostPreviewTableViewCell else {
            return UITableViewCell()
        }
        let post = posts[indexPath.row]
        cell.configure(with: .init(title: post.title, imageURL: post.headerImageUrl))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var isOwnedByCurrentUser = false
        if let email = UserDefaults.standard.string(forKey: "email"){
            isOwnedByCurrentUser = email == currentEmail
        }
        let vc = ViewPostViewController(post: posts[indexPath.row], isOwnedByCurrentUser: isOwnedByCurrentUser)
        vc.title = posts[indexPath.row].title
        navigationController?.pushViewController(vc, animated: false)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else {
            return
        }
        StorageManager.shared.uploadUserProfilePicture(email: currentEmail, image: image){[weak self] uploaded in
            guard let self = self else {return}
            if uploaded {
                DatabaseManager.shared.updateProfileData(email: self.currentEmail){ updated in
                    guard updated else { return }
                    DispatchQueue.main.async {
                        self.fetchProfileDate()
                        picker.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
}
