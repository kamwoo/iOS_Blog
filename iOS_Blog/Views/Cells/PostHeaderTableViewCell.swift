//
//  PostHeaderTableViewCell.swift
//  iOS_Blog
//
//  Created by wooyeong kam on 2021/11/12.
//

import UIKit

struct PostHeaderTableViewCellModel {
    let imageURL: URL?
    var imageData: Data?
    
    init(url: URL?) {
        self.imageURL = url
    }
}

class PostHeaderTableViewCell: UITableViewCell {
    
    static let identifier = "PostHeaderTableViewCell"

    private let postImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.clipsToBounds = true
        contentView.addSubview(postImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        postImageView.frame = contentView.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        postImageView.image = nil
    }
    
    func configure(with viewModel: PostHeaderTableViewCellModel){
        if let data = viewModel.imageData{
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
