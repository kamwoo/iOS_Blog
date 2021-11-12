//
//  SignUpViewController.swift
//  iOS_Blog
//
//  Created by wooyeong kam on 2021/11/10.
//

import UIKit

class SignUpViewController: UIViewController {

    private let HeaderView = SignInHeaderView()
    
    private let nameField: UITextField = {
       let field = UITextField()
        field.placeholder = "이름을 입력해주세요."
        field.autocorrectionType = .no
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        field.leftViewMode = .always
        field.layer.masksToBounds = true
        field.layer.cornerRadius = 8
        field.returnKeyType = .continue
        field.backgroundColor = .secondarySystemBackground
        return field
    }()
    
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
    
    private let createAccountButton: UIButton = {
       let button = UIButton()
        button.setTitle("계정 만들기", for: .normal)
        button.backgroundColor = .link
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .heavy)
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 5
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "계정 만들기"
        
        view.addSubview(HeaderView)
        view.addSubview(nameField)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(createAccountButton)
        
        createAccountButton.addTarget(self, action: #selector(didTapCreateAccountButton), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        HeaderView.frame = CGRect(x: 0, y: view.safeAreaInsets.top, width: view.width, height: view.height/4)
        let fieldSize : CGFloat = view.width*3/4
        nameField.frame = CGRect(x: HeaderView.center.x - fieldSize/2, y: HeaderView.bottom+20, width: fieldSize, height: 40)
        emailField.frame = CGRect(x: HeaderView.center.x - fieldSize/2, y: nameField.bottom+10, width: fieldSize, height: 40)
        passwordField.frame = CGRect(x: HeaderView.center.x - fieldSize/2, y: emailField.bottom+10, width: fieldSize, height: 40)
        createAccountButton.frame = CGRect(x: HeaderView.center.x - fieldSize/2, y: passwordField.bottom+10, width: fieldSize, height: 40)
    }
    
    @objc private func didTapCreateAccountButton(){
        guard let email = emailField.text,
              let password = passwordField.text,
              let name = nameField.text,
              !email.isEmpty, !password.isEmpty,!name.isEmpty, password.count >= 6 else {
            return
        }
        AuthManager.shared.signUp(email: email, password: password){[weak self] result in
            if result {
                let newUser = User(name: name, email: email, profilePictureURL: nil)
                DatabaseManager.shared.insertUser(user: newUser){ inserted in
                    UserDefaults.standard.setValue(email, forKey: "email")
                    UserDefaults.standard.setValue(name, forKey: "name")
                    DispatchQueue.main.async {
                        let vc = TabBarViewController()
                        vc.modalPresentationStyle = .fullScreen
                        self?.present(vc, animated: true, completion: nil)
                    }
                }
            }else {
                print("failed to create account")
            }
        }
    }

}
