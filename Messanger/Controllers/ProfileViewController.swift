//
//  ProfileViewController.swift
//  Messanger
//
//  Created by 丹野健心 on 2022/04/07.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import GoogleSignIn

class ProfileViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    let data = ["Log Out"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
    }
    
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = .red
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let actionSheet = UIAlertController(title: "",
                                            message: "",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Log Out",
                                            style: .destructive,
                                            handler: { [weak self] _ in
            
            guard let strongSelf = self else {
                return
            }
            
            // Log Out facebook
            FBSDKLoginKit.LoginManager().logOut()
            
            // Google Log out
            GIDSignIn.sharedInstance().signOut()
            
            do {
                try FirebaseAuth.Auth.auth().signOut()
                
                let vc = LoginViewController()
                let nav = UINavigationController(rootViewController: vc)
                let navBarAppearance = UINavigationBarAppearance()
                
                navBarAppearance.backgroundColor = .rgb(red: 255, green: 255, blue: 255)
                nav.navigationBar.standardAppearance = navBarAppearance
                nav.navigationBar.scrollEdgeAppearance = navBarAppearance
                nav.modalPresentationStyle = .fullScreen
                strongSelf.present(nav, animated: false)
            }
            catch {
                print("Failed to log out")
            }
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel",
                                            style: .cancel,
                                            handler: nil))
        
        present(actionSheet, animated: true)
    }
}
