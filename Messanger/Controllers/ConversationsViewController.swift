//
//  ViewController.swift
//  Messanger
//
//  Created by 丹野健心 on 2022/04/07.
//

import UIKit
import FirebaseAuth

class ConversationsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .magenta
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        validateAuth()
    }
    
    private func validateAuth() {
        if FirebaseAuth.Auth.auth().currentUser == nil {
            let vc = LoginViewController()
            let nav = UINavigationController(rootViewController: vc)
            let navBarAppearance = UINavigationBarAppearance()
            
            navBarAppearance.backgroundColor = .rgb(red: 255, green: 255, blue: 255)
            nav.navigationBar.standardAppearance = navBarAppearance
            nav.navigationBar.scrollEdgeAppearance = navBarAppearance
            nav.modalPresentationStyle = .fullScreen
            present(nav, animated: false)
        }
    }


}

