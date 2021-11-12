//
//  PayWllDescriptionView.swift
//  iOS_Blog
//
//  Created by wooyeong kam on 2021/11/12.
//

import UIKit

class PayWllDescriptionView: UIView {

    private let descriptionLabel: UILabel = {
       let lable = UILabel()
        lable.textAlignment = .center
        lable.font = .systemFont(ofSize: 26, weight: .medium)
        lable.numberOfLines = 0
        lable.text = "프리미엄 구독하시고 무한한 피드를 맛보세요!"
        return lable
    }()
    
    private let priceLabel: UILabel = {
       let lable = UILabel()
        lable.textAlignment = .center
        lable.font = .systemFont(ofSize: 22, weight: .light)
        lable.numberOfLines = 0
        lable.text = "KW 1400 / 월"
        return lable
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        clipsToBounds = true
        addSubview(descriptionLabel)
        addSubview(priceLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        descriptionLabel.frame = CGRect(x: 20, y: 0, width: width-40, height: height/2)
        priceLabel.frame = CGRect(x: 20, y: descriptionLabel.bottom, width: width-40, height: height/2)
    }
}
