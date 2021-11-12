//
//  ViewController.swift
//  iOS_Blog
//
//  Created by wooyeong kam on 2021/11/10.
//

import UIKit

class HomeViewController: UIViewController {
    
    private var posts = [BlogPost]()
    
    private let tableView: UITableView = {
       let tableView = UITableView()
        tableView.register(PostPreviewTableViewCell.self,
                           forCellReuseIdentifier: PostPreviewTableViewCell.identifer)
        return tableView
    }()
    
    private let composeButton: UIButton = {
       let button = UIButton()
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.setImage(UIImage(systemName: "pencil",
                                withConfiguration: UIImage.SymbolConfiguration(
                                    pointSize: 30, weight: .medium)),
                        for: .normal)
        button.layer.shadowColor = UIColor.label.cgColor
        button.layer.shadowOpacity = 0.4
        button.layer.shadowRadius = 10
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(composeButton)
        composeButton.addTarget(self, action: #selector(didTapComposeButton), for: .touchUpInside)
        fetchPosts()
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        let buttonSize : CGFloat = view.width/7
        composeButton.frame = CGRect(x: view.right-buttonSize-10,
                                     y: view.bottom-buttonSize-10-view.safeAreaInsets.bottom,
                                     width: buttonSize,
                                     height: buttonSize)
        composeButton.layer.cornerRadius = buttonSize/2
    }
    
    @objc private func didTapComposeButton(){
        let vc = CreateNewPostViewController()
        vc.title = "새로운 포스트 작성"
        let nav = UINavigationController(rootViewController: vc)
        nav.navigationBar.prefersLargeTitles = true
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
    
    private func fetchPosts(){
        DatabaseManager.shared.getAllPost{ [weak self] allposts in
            self?.posts = allposts
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
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
        let vc = ViewPostViewController(post: posts[indexPath.row])
        vc.title = posts[indexPath.row].title
        navigationController?.pushViewController(vc, animated: false)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
