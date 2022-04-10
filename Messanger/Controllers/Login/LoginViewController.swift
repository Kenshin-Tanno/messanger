//
//  LoginViewController.swift
//  Messanger
//
//  Created by 丹野健心 on 2022/04/07.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
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
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "only_us")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Login"
        view.backgroundColor = .white
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Resister",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapResister))
        navigationItem.rightBarButtonItem?.tintColor = .black
        self.navigationController?.navigationBar.tintColor = .black
        
        loginButton.addTarget(self,
                              action: #selector(loginButtonTapped),
                              for: .touchUpInside)
        
        emailField.delegate = self
        passwordField.delegate = self
        
        //        Add subviews
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(loginButton)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        
        let size = scrollView.width/3
        let loginButtonSize = size - 20
        let fieldSize = scrollView.width-120
        let fieldX: CGFloat = (scrollView.width-fieldSize)/2
        let height: CGFloat = 45
        let addY: CGFloat = 20
        imageView.frame = CGRect(x: (scrollView.width-size)/2,
                                 y: 20,
                                 width: size,
                                 height: size)
        emailField.frame = CGRect(x: fieldX,
                                  y: imageView.bottom+addY,
                                  width: fieldSize,
                                  height: height)
        passwordField.frame = CGRect(x: fieldX,
                                     y: emailField.bottom+addY,
                                     width: fieldSize,
                                     height: height)
        loginButton.frame = CGRect(x: (scrollView.width-loginButtonSize)/2,
                                   y: passwordField.bottom+addY + 5,
                                   width: loginButtonSize,
                                   height: height + 5)
        buttonGradient(button: loginButton)
    }
    
    @objc private func didTapResister() {
        let vc = ResisterViewController()
        vc.title = "Create Account"
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func loginButtonTapped() {
        
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        guard let email = emailField.text, let password = passwordField.text,
              !email.isEmpty, !password.isEmpty, password.count >= 6 else {
                  alertUserLoginError()
                  return
              }
        
//        Firebase Login
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let strongSelf = self else {
                return
            }
            guard let result = authResult, error == nil else {
                print("Failed to log in user with email: \(email)")
                return
            }
            
            let user = result.user
            print("Logged in User: \(user)")
            strongSelf.navigationController?.dismiss(animated: true)
        }
    }
    
    func alertUserLoginError() {
        let alert = UIAlertController(title: "Woops",
                                      message: "Please enter all information to log in.",
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
        loginButton.layer.insertSublayer(gradientLayer, at:0)
    }
    
    
    
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == emailField {
            passwordField.becomeFirstResponder()
        }
        else if textField == passwordField {
            loginButtonTapped()
        }
        
        return true
    }
}
