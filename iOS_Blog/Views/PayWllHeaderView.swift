//
//  PayWllHeaderView.swift
//  iOS_Blog
//
//  Created by wooyeong kam on 2021/11/12.
//

import UIKit

class PayWllHeaderView: UIView {
    private let headerImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(systemName: "crown.fill")
        imageView.tintColor = .yellow
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        clipsToBounds = true
        addSubview(headerImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let size : CGFloat = 150
        headerImageView.frame = CGRect(x: width/2-size/2, y: height/2-size/2, width: size, height: size)
    }
}
