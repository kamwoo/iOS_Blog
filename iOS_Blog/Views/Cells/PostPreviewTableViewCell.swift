//
//  PostPreviewTableViewCell.swift
//  iOS_Blog
//
//  Created by wooyeong kam on 2021/11/12.
//

import UIKit

struct PostPreviewTableViewCellModel {
    let title: String
    let imageURL: URL?
    var imageData: Data?
    
    init(title: String, imageURL: URL?) {
        self.title = title
        self.imageURL = imageURL
    }
}

class PostPreviewTableViewCell: UITableViewCell {
    static let identifer = "PostPreviewTableViewCell"
    
    private let postImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let postTitleLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 20, weight: .medium)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        contentView.addSubview(postImageView)
        contentView.addSubview(postTitleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        postImageView.frame = CGRect(x: 5, y: 5, width: contentView.height-10, height: contentView.height-10)
        postTitleLabel.sizeToFit()
        postTitleLabel.frame = CGRect(x: postImageView.right + 10, y: 5, width: postTitleLabel.width, height: postTitleLabel.height)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        postImageView.image = nil
        postTitleLabel.text = nil
    }
    
    func configure(with viewModel: PostPreviewTableViewCellModel){
        postTitleLabel.text = viewModel.title
        
        if let data = viewModel.imageData {
            postImageView.image = UIImage(data: data)
        }
        else if let url = viewModel.imageURL {
            // fetch and cache
            URLSession.shared.dataTask(with: url){ [weak self] data, _, _ in
                guard let data = data else { return }
                DispatchQueue.main.async {
                    self?.postImageView.image = UIImage(data: data)
                }
            }.resume()
        }
    }
}
