//
//  SignInViewController.swift
//  iOS_Blog
//
//  Created by wooyeong kam on 2021/11/10.
//

import UIKit

class SignInViewController: UIViewController {
    
    private let HeaderView = SignInHeaderView()
    
    private let emailField: UITextField = {
       let field = UITextField()
        field.keyboardType = .emailAddress
        field.placeholder = "이메일을 입력해주세요."
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.leftViewMode = .always
        field.layer.masksToBounds = true
        field.layer.cornerRadius = 8
        field.returnKeyType = .continue
        field.backgroundColor = .secondarySystemBackground
        return field
    }()
    
    private let passwordField: UITextField = {
       let field = UITextField()
        field.isSecureTextEntry = true
        field.placeholder = "비밀번호를 입력해주세요."
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.leftViewMode = .always
        field.layer.masksToBounds = true
        field.layer.cornerRadius = 8
        field.returnKeyType = .continue
        field.backgroundColor = .secondarySystemBackground
        return field
    }()
    
    private let signInButton: UIButton = {
       let button = UIButton()
        button.setTitle("로그인", for: .normal)
        button.backgroundColor = .link
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .heavy)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 5
        return button
    }()
    
    private let createAccountButton: UIButton = {
       let button = UIButton()
        button.setTitle("계정 만들기", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .light)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "로그인"
        DispatchQueue.main.asyncAfter(deadline: .now()+2) {
            if !IAPManager.shared.isPremium(){
                let vc = PayWallViewController()
                let nav = UINavigationController(rootViewController: vc)
                self.present(nav, animated: true, completion: nil)
            }
        }
        view.addSubview(HeaderView)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(signInButton)
        view.addSubview(createAccountButton)
        
        signInButton.addTarget(self, action: #selector(didTapSignInButton), for: .touchUpInside)
        createAccountButton.addTarget(self, action: #selector(didTapCreateAccountButton), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        HeaderView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: view.height/4)
        let fieldSize : CGFloat = view.width*3/4
        emailField.frame = CGRect(x: HeaderView.center.x - fieldSize/2, y: HeaderView.bottom+20, width: fieldSize, height: 40)
        passwordField.frame = CGRect(x: HeaderView.center.x - fieldSize/2, y: emailField.bottom+10, width: fieldSize, height: 40)
        let buttonSize : CGFloat = view.width/2
        signInButton.frame = CGRect(x: HeaderView.center.x - fieldSize/2, y: passwordField.bottom+20, width: fieldSize, height: 40)
        createAccountButton.frame = CGRect(x: HeaderView.center.x - buttonSize/2, y: signInButton.bottom+10, width: buttonSize, height: 30)
    }
    
    @objc private func didTapSignInButton(){
        guard let email = emailField.text, let password = passwordField.text,
              !email.isEmpty, !password.isEmpty else {
            return
        }
        AuthManager.shared.signIn(email: email, password: password){ [weak self] result in
            guard result else {return}
            UserDefaults.standard.setValue(email, forKey: "email")
            DispatchQueue.main.async {
                let vc = TabBarViewController()
                vc.modalPresentationStyle = .fullScreen
                self?.present(vc, animated: true, completion: nil)
            }
            
        }
    }
    
    @objc private func didTapCreateAccountButton(){
        let vc = SignUpViewController()
        vc.title = "계정 만들기"
        navigationController?.pushViewController(vc, animated: true)
    }

}
