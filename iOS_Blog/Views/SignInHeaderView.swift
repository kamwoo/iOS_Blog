//
//  SignInHeaderView.swift
//  iOS_Blog
//
//  Created by wooyeong kam on 2021/11/11.
//

import UIKit

class SignInHeaderView: UIView {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "person"))
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .systemBackground
        return imageView
    }()
    
    private let label: UILabel = {
       let label = UILabel()
        label.text = "수많은 사람들의 피드를 탐험하세요!"
        label.font = .systemFont(ofSize: 22, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imageView)
        addSubview(label)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let size : CGFloat = width/4
        imageView.frame = CGRect(x: width/2 - size/2 , y: size/2, width: size, height: size)
        label.sizeToFit()
        label.frame = CGRect(x: imageView.center.x - label.width/2, y: imageView.bottom + 10, width: label.width, height: label.height)
    }

}
