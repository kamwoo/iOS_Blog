//
//  PayWallViewController.swift
//  iOS_Blog
//
//  Created by wooyeong kam on 2021/11/12.
//

import UIKit

class PayWallViewController: UIViewController {
    
    //Close Button
    //header image
    private let headerView = PayWllHeaderView()
    //pricing and product info
    private let infoView = PayWllDescriptionView()
    //CTA button
    private let buyButton: UIButton = {
       let button = UIButton()
        button.setTitle("구독하기", for: .normal)
        button.backgroundColor = .link
        button.setTitleColor(.white, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let restoreButton: UIButton = {
       let button = UIButton()
        button.setTitle("구매 저장하기", for: .normal)
        button.setTitleColor(.link, for: .normal)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 8
        return button
    }()
    //Terms of service
    private let termsView: UITextView = {
       let view = UITextView()
        view.isEditable = false
        view.textAlignment = .center
        view.font = .systemFont(ofSize: 14, weight: .medium)
        view.textColor = .secondaryLabel
        view.text = "프리미엄 정기 구독권입니다. 아이튠즈 계정으로 매달 계산되며, 언제든 해지가능합니다."
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupCloseButton()
        view.addSubview(headerView)
        view.addSubview(infoView)
        view.addSubview(buyButton)
        view.addSubview(restoreButton)
        configButtons()
        view.addSubview(termsView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        headerView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: view.height/3)
        termsView.frame = CGRect(x: 10, y: view.height-100, width: view.width-20, height: 100)
        let buttonSize : CGFloat = view.width - 50
        restoreButton.frame = CGRect(x: view.width/2 - buttonSize/2,
                                     y: termsView.top-10-50, width: buttonSize, height: 50)
        buyButton.frame = CGRect(x: view.width/2 - buttonSize/2,
                                 y: restoreButton.top-10-50, width: buttonSize, height: 50)
        infoView.frame = CGRect(x: 0, y: headerView.bottom, width: view.width, height: buyButton.top-view.safeAreaInsets.top-headerView.height)
    }
    
    private func configButtons(){
        buyButton.addTarget(self, action: #selector(didTapBuyBtn), for: .touchUpInside)
        restoreButton.addTarget(self, action: #selector(didTapRestoreBtn), for: .touchUpInside)
    }
    
    @objc private func didTapBuyBtn(){
        
    }
    
    @objc private func didTapRestoreBtn(){
        
    }
    
    private func setupCloseButton(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose,
                                                            target: self,
                                                            action: #selector(didTapClose))
        
    }
    
    @objc private func didTapClose(){
        dismiss(animated: true, completion: nil)
    }
    
}
