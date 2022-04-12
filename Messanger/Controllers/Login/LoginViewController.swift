//
//  LoginViewController.swift
//  Messanger
//
//  Created by 丹野健心 on 2022/04/07.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import GoogleSignIn

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
    
    private let facebookLoginButton: FBLoginButton = {
        let button = FBLoginButton()
        button.permissions = ["email", "public_profile"]
        return button
    }()
    
    private let googleLoginButton = GIDSignInButton()
    
    private var loginObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginObserver = NotificationCenter.default.addObserver(forName: .didLoginNotification,object: nil,queue: .main,using: { [weak self] _ in
            guard let strongSelf = self else {
                return
            }
            
            strongSelf.navigationController?.dismiss(animated: true)
        })
        
        GIDSignIn.sharedInstance().presentingViewController = self
        
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
        facebookLoginButton.delegate = self
        
        //        Add subviews
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(loginButton)
        scrollView.addSubview(facebookLoginButton)
        scrollView.addSubview(googleLoginButton)
    }
    
    deinit {
        if let observer = loginObserver {
            NotificationCenter.default.removeObserver(observer)
        }
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
        facebookLoginButton.frame = CGRect(x: fieldX,
                                           y: loginButton.bottom + addY + 20,
                                           width: fieldSize,
                                           height: height)
        googleLoginButton.frame = CGRect(x: fieldX,
                                         y: facebookLoginButton.bottom + addY + 5,
                                         width: fieldSize,
                                         height: height)
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

extension LoginViewController: UITextFieldDelegate, LoginButtonDelegate {
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        // no operation
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        guard let token = result?.token?.tokenString else {
            print("User failed to log in with facebook")
            return
        }
        
        let facebookRequest = FBSDKLoginKit.GraphRequest(graphPath: "me",
                                                         parameters: ["fields": "email, name"],
                                                         tokenString: token,
                                                         version: nil,
                                                         httpMethod: .get)
        
        facebookRequest.start { _, result, error in
            guard let result = result as? [String: Any],
                  error == nil else {
                print("Failed to make facebook graph request")
                return
            }
            
            print("\(result)")
            
            guard var userName = result["name"] as? String,
                  let email = result["email"] as? String else {
                print("Failed to get email and name from fb result")
                return
            }
            
            if !userName.contains(" ") {
                userName.insert(" ", at: userName.index(userName.startIndex, offsetBy: 2))
            }
            
            let nameComponents = userName.components(separatedBy: " ")
            
            guard nameComponents.count == 2 else {
                return
            }
            
            let firstName = nameComponents[0]
            let lastName = nameComponents[1]
            
            DatabaseManager.shared.userExists(with: email) { exists in
                if !exists {
                    DatabaseManager.shared.insertUser(with: ChatAppUser(firstName: firstName,
                                                                        lastName: lastName,
                                                                        emailAddress: email))
                }
            }
            
            let credential = FacebookAuthProvider.credential(withAccessToken: token)
            FirebaseAuth.Auth.auth().signIn(with: credential) { [weak self] authResult, error in
                guard let strongSelf = self else {
                    return
                }
                
                guard authResult != nil, error == nil else {
                    if let error = error {
                        print("Facebook credential login failed, MFA may be needed - \(error)")
                    }
                    
                    return
                }
                
                print("Successfully logged user in")
                strongSelf.navigationController?.dismiss(animated: true)
            }
        }
    }
    
    
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

