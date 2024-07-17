//
//  LoginViewController.swift
//  DemoCode
//
//  Created by codiant on 26/02/24.
//

import UIKit

class LoginViewController: UIViewController {

    // MARK: - Instance Variables
    var router: LoginRouterProtocol!
    private lazy var presenter = {
      return LoginPresenter(self)
    }()
    
    //MARK: - IBOutlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var showPasswordButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    //MARK: - Button Actions
    
    @IBAction func showPasswordButton(_ sender: UIButton) {
        if presenter.showPassword {
            presenter.showPassword = false
            passwordTextField.isSecureTextEntry = true
            showPasswordButton.setImage(UIImage(named: "show"), for: .normal)
        } else {
            presenter.showPassword = true
            passwordTextField.isSecureTextEntry = false
            showPasswordButton.setImage(UIImage(named: "hide"), for: .normal)
        }
    }
    
    @IBAction func forgotPasswordButton(_ sender: UIButton) {
        self.showAlertWith(message: "This feature is not available")

    }
    
    @IBAction func signUpButton(_ sender: UIButton) {
        let viewController = StoryboardScene.Account.instantiateViewController(withClass: SignUpViewController.self)
        navigationController?.pushViewController(viewController, animated: true)

    }
    
    @IBAction func googleButton(_ sender: UIButton) {
        self.showAlertWith(message: "This feature is not available")

    }
    
    @IBAction func loginButton(_ sender: UIButton) {
        guard presenter.isTextFieldsValid(email: emailTextField.text!, password: passwordTextField.text!) else { return }
        presenter.login(email: emailTextField.text!, password: passwordTextField.text!)

    }

    func routeToHome() {
        let viewController = StoryboardScene.Account.instantiateViewController(withClass: HomeViewController.self)
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension LoginViewController: LoginView {
    func loginSuccess() {
        self.routeToHome()
    }
    
    func showAlert(_ message: String) {
        self.showAlertWith(message: message)

    }

}
