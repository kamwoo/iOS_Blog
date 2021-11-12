//
//  TabBarViewController.swift
//  iOS_Blog
//
//  Created by wooyeong kam on 2021/11/10.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setupControllers()
    }
    
    private func setupControllers(){
        guard let email = UserDefaults.standard.string(forKey: "email") else {
            print("userdefualt email is nil")
            return
        }
        let home = HomeViewController()
        let Profile = ProfileViewController(currentEmail: email)
        
        home.title = "Home"
        Profile.title = "Profile"
        home.navigationItem.largeTitleDisplayMode = .always
        Profile.navigationItem.largeTitleDisplayMode = .always
        
        let homeNav = UINavigationController(rootViewController: home)
        let ProfileNav = UINavigationController(rootViewController: Profile)
        
        homeNav.navigationBar.prefersLargeTitles = true
        ProfileNav.navigationBar.prefersLargeTitles = true
        
        homeNav.tabBarItem = UITabBarItem(title: "Home", image: UIImage(systemName: "house"), tag: 1)
        ProfileNav.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), tag: 2)
        
        setViewControllers([homeNav, ProfileNav], animated: false)
    }
}
