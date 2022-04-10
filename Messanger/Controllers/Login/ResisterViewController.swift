//
//  ResisterViewController.swift
//  Messanger
//
//  Created by 丹野健心 on 2022/04/07.
//

import UIKit
import Firebase

class ResisterViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let firstNameField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 10
        field.layer.borderWidth = 0.3
        field.layer.backgroundColor = UIColor.rgb(red: 255, green: 249, blue: 245).cgColor
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "First Name..."
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        return field
    }()
    
    private let lastNameField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 10
        field.layer.borderWidth = 0.3
        field.layer.backgroundColor = UIColor.rgb(red: 255, green: 249, blue: 245).cgColor
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Last Name..."
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        return field
    }()
    
    private let emailField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 10
        field.layer.borderWidth = 0.3
        field.layer.backgroundColor = UIColor.rgb(red: 255, green: 249, blue: 245).cgColor
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Email Address..."
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        return field
    }()
    
    private let passwordField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .done
        field.layer.cornerRadius = 10
        field.layer.borderWidth = 0.3
        field.layer.backgroundColor = UIColor.rgb(red: 255, green: 249, blue: 245).cgColor
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Password..."
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.isSecureTextEntry = true
        return field
    }()
    
    private let resisterButton: UIButton = {
        let button = UIButton()
        button.setTitle("Resister", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.circle")
        imageView.tintColor = UIColor.rgb(red: 211, green: 48, blue: 129)
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 1
        imageView.layer.borderColor = UIColor.rgb(red: 211, green: 48, blue: 129).cgColor
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Create Account"
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Resister",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapResister))
        navigationItem.rightBarButtonItem?.tintColor = .black
        
        resisterButton.addTarget(self,
                                 action: #selector(resisterButtonTapped),
                                 for: .touchUpInside)
        
        emailField.delegate = self
        passwordField.delegate = self
        
        //        Add subviews
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(firstNameField)
        scrollView.addSubview(lastNameField)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(resisterButton)
        
        imageView.isUserInteractionEnabled = true
        scrollView.isUserInteractionEnabled = true
        
        let gesture = UITapGestureRecognizer(target: self,
                                             action: #selector(didTapChangeProfilePic))
        
        imageView.addGestureRecognizer(gesture)
    }
    
    @objc private func didTapChangeProfilePic() {
        presentPhotoActionSheet()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        
        let size = scrollView.width/3
        let resisterButtonSize = size - 20
        let fieldSize = scrollView.width-120
        let fieldX: CGFloat = (scrollView.width-fieldSize)/2
        let height: CGFloat = 45
        let addY: CGFloat = 20
        imageView.frame = CGRect(x: (scrollView.width-size)/2,
                                 y: 20,
                                 width: size,
                                 height: size)
        imageView.layer.cornerRadius = imageView.width / 2.0
        
        firstNameField.frame = CGRect(x: fieldX,
                                      y: imageView.bottom+addY,
                                      width: fieldSize,
                                      height: height)
        lastNameField.frame = CGRect(x: fieldX,
                                     y: firstNameField.bottom+addY,
                                     width: fieldSize,
                                     height: height)
        emailField.frame = CGRect(x: fieldX,
                                  y: lastNameField.bottom+addY,
                                  width: fieldSize,
                                  height: height)
        passwordField.frame = CGRect(x: fieldX,
                                     y: emailField.bottom+addY,
                                     width: fieldSize,
                                     height: height)
        resisterButton.frame = CGRect(x: (scrollView.width-resisterButtonSize)/2,
                                      y: passwordField.bottom+addY + 5,
                                      width: resisterButtonSize,
                                      height: height + 5)
        buttonGradient(button: resisterButton)
    }
    
    @objc private func didTapResister() {
        let vc = ResisterViewController()
        vc.title = "Create Account"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func resisterButtonTapped() {
        
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        firstNameField.resignFirstResponder()
        lastNameField.resignFirstResponder()
        
        guard let firstName = firstNameField.text,
              let lastName = lastNameField.text,
              let email = emailField.text,
              let password = passwordField.text,
              !email.isEmpty,
              !password.isEmpty,
              !firstName.isEmpty,
              !lastName.isEmpty,
              password.count >= 6 else {
            alertUserLoginError()
            return
        }
        
        //        Firebase Login
        
        DatabaseManager.shared.userExists(with: email) { [weak self] exists in
            guard let strongSelf = self else {
                return
            }
            
            guard !exists else {
                //user already exists
                strongSelf.alertUserLoginError(message: "Looks like a user account for that email address already exists.")
                return
            }
            
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                guard authResult != nil, error == nil else {
                    print("Error creating user")
                    return
                }
                
                DatabaseManager.shared.insertUser(with: ChatAppUser(firstName: firstName,
                                                                    lastName: lastName,
                                                                    emailAddress: email))
                strongSelf.navigationController?.dismiss(animated: true)
            }
        }
    }
    
    func alertUserLoginError(message: String = "Please enter all information to create a new account.") {
        let alert = UIAlertController(title: "Woops",
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss",
                                      style: .cancel,
                                      handler: nil))
        present(alert, animated: true)
    }
    
    private func buttonGradient(button: UIButton) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = button.bounds
        gradientLayer.colors = [
            UIColor(red: 245/255, green: 197/255, blue: 203/255, alpha: 1).cgColor,
            UIColor(red: 236/255, green: 158/255, blue: 183/255, alpha: 1).cgColor,
            UIColor(red: 231/255, green: 136/255, blue: 172/255, alpha: 1).cgColor,
            UIColor(red: 226/255, green: 114/255, blue: 161/255, alpha: 1).cgColor,
            UIColor(red: 211/255, green: 48/255, blue: 129/255, alpha: 1).cgColor
        ]
        gradientLayer.locations = [
            0,
            0.21,
            0.30,
            0.39,
            1
        ]
        gradientLayer.shouldRasterize = true
        gradientLayer.cornerRadius = 12
        gradientLayer.startPoint = CGPoint(x: 0, y: 0) // Top left corner.
        gradientLayer.endPoint = CGPoint(x: 1, y: 1) // Bottom right corner.
        resisterButton.layer.insertSublayer(gradientLayer, at:0)
    }
    
    
    
}

extension ResisterViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == emailField {
            passwordField.becomeFirstResponder()
        }
        else if textField == passwordField {
            resisterButtonTapped()
        }
        
        return true
    }
}

extension ResisterViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "Profile Picture",
                                            message: "How would you like to select a picture",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel",
                                            style: .cancel,
                                            handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Take Photo",
                                            style: .default,
                                            handler:  { [weak self] _ in
            
            self?.presentCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Chose Photo",
                                            style: .default,
                                            handler: { [weak self] _ in
            
            self?.presentPhotoPicker()
        }))
        
        present(actionSheet, animated: true)
    }
    
    func presentCamera() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func presentPhotoPicker() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        self.imageView.image = selectedImage
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

