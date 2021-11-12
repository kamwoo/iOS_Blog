//
//  CreateNewPostViewController.swift
//  iOS_Blog
//
//  Created by wooyeong kam on 2021/11/10.
//

import UIKit

class CreateNewPostViewController: UIViewController {
    
    private let headerImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "photo")
        imageView.backgroundColor = .tertiarySystemBackground
        imageView.isUserInteractionEnabled = true
        
        return imageView
    }()
    
    private let titleField: UITextField = {
       let field = UITextField()
        field.placeholder = "제목을 입력해주세요."
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
    
    private let textview: UITextView = {
       let textView = UITextView()
        textView.backgroundColor = .secondarySystemBackground
        textView.isEditable = true
        textView.font = .systemFont(ofSize: 28)
        textView.layer.masksToBounds = true
        textView.layer.cornerRadius = 8
        return textView
    }()
    
    private var selectedHeaderImage: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureButton()
        view.addSubview(headerImageView)
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapPicture))
        headerImageView.addGestureRecognizer(gesture)
        view.addSubview(titleField)
        view.addSubview(textview)
        
    }
    private func configureButton(){
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "취소",
                                                           style: .done,
                                                           target: self,
                                                           action: #selector(didTapCancle))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "포스트",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapComplete))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        headerImageView.frame = CGRect(x: 0,
                                       y: 200,
                                       width: view.width,
                                       height: view.height/4)
        titleField.frame = CGRect(x: 20,
                                  y: headerImageView.bottom + 20,
                                  width: view.width-40,
                                  height: 40)
        textview.frame = CGRect(x: titleField.left,
                                y: titleField.bottom + 10,
                                width: view.width - 40,
                                height: view.height/2)
    }
    
    @objc private func didTapPicture(){
        let pickerView = UIImagePickerController()
        pickerView.sourceType = .photoLibrary
        pickerView.delegate = self
        present(pickerView, animated: true)
    }
    
    @objc private func didTapCancle(){
        dismiss(animated: true)
    }
    
    @objc private func didTapComplete(){
        guard let title = titleField.text,
              let body = textview.text,
              let headerImage = selectedHeaderImage,
              let email = UserDefaults.standard.string(forKey: "email"),
              !title.trimmingCharacters(in: .whitespaces).isEmpty,
              !body.trimmingCharacters(in: .whitespaces).isEmpty
              else {
            let alert = UIAlertController(title: "포스트 실패", message: "포스트를 전부 입력해주세요", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .cancel))
            present(alert, animated: true)
            return
        }
        let newId = UUID().uuidString
        
        StorageManager.shared.uploadBlogHeaderImage(
            email: email,image: headerImage,postId: newId){[weak self] result in
            guard result else {
                print("fail to uploadBlogHeaderImage")
                return
            }
            StorageManager.shared.downloadUrlForPostHeader(email: email, postId: newId){ url in
                guard let headerUrl = url else {
                    print("failed to downloadUrlForPostHeader")
                    return
                }
                
                let post = BlogPost(identifier: newId,
                                    title: title,
                                    timestamp: Date().timeIntervalSince1970,
                                    headerImageUrl: headerUrl,
                                    text: body)
                
                DatabaseManager.shared.insert(blogpost: post, email: email){ posted in
                    guard posted else {
                        print("failed to insert")
                        return
                    }
                    DispatchQueue.main.async {
                        self?.didTapCancle()
                    }
                }
            }
        }
        
        
    }
}

extension CreateNewPostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.originalImage] as? UIImage else {
            return
        }
        selectedHeaderImage = image
        headerImageView.image = image
        picker.dismiss(animated: true)
    }
}
