//
//  ViewPostViewController.swift
//  iOS_Blog
//
//  Created by wooyeong kam on 2021/11/10.
//

import UIKit

class ViewPostViewController: UIViewController {
    
    private let post : BlogPost
    private let isOwnedByCurrentUser: Bool
    
    private let tableView: UITableView = {
       let view = UITableView()
        view.register(PostHeaderTableViewCell.self,
                      forCellReuseIdentifier: PostHeaderTableViewCell.identifier)
        view.register(UITableViewCell.self,
                      forCellReuseIdentifier: "cell")
        return view
    }()
    
    init(post : BlogPost, isOwnedByCurrentUser:Bool = false) {
        self.post = post
        self.isOwnedByCurrentUser = isOwnedByCurrentUser
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        if !isOwnedByCurrentUser {
            IAPManager.shared.logPostViewed()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
}

extension ViewPostViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        switch index {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = post.title
            cell.textLabel?.numberOfLines = 0
            cell.selectionStyle = .none
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PostHeaderTableViewCell.identifier,
                                                           for: indexPath) as? PostHeaderTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: .init(url: post.headerImageUrl))
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.textLabel?.text = post.text
            cell.textLabel?.numberOfLines = 0
            return cell
        default:
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1 {
            return 200
        }
        else{
            return UITableView.automaticDimension
        }
    }
}
