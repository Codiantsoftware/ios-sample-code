//
//  SplashViewController.swift
//  DemoCode
//
//  Created by codiant on 26/02/24.
//

import UIKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
    }
    
    
    
    func configure() {
        if userDefault.object(forKey: "KEYCHAIN_ID") != nil {
            do {
                try Authorization.shared.restoreAuthorization()
                self.setRootHome()
            } catch {
                self.setRootLogin()
            }
        } else {
            self.setRootLogin()
        }
        
    }
    
    func setRootLogin() {
        let viewController = StoryboardScene.Account.instantiateViewController(withClass: LoginViewController.self)
        navigationController?.pushViewController(viewController, animated: true)

    }
    
    func setRootHome() {
        let viewController = StoryboardScene.Account.instantiateViewController(withClass: HomeViewController.self)
        navigationController?.pushViewController(viewController, animated: true)

    }

}
