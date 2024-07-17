//
//  SignUpViewController.swift
//  DemoCode
//
//  Created by codiant on 26/02/24.
//

import UIKit

class SignUpViewController: UIViewController {

    // MARK: - Instance Variables
    var router: SignUpRouterProtocol!
    private lazy var presenter = {
      return SignUpPresenter(self)
    }()
    
    //MARK: - IBOutlets
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var showPasswordButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
    }
    
    //MARK: - Initial Setup
    
    func configure() {
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
    
    @IBAction func signUpButton(_ sender: UIButton) {
        print("signup clicked")
        guard presenter.isTextFieldsValid(firstName: firstNameTextField.text!, lastName: lastNameTextField.text!, email: emailTextField.text!, phone: phoneTextField.text!, password: passwordTextField.text!) else { return }
        presenter.signUp(firstName: firstNameTextField.text!, lastName: lastNameTextField.text!, email: emailTextField.text!, phone: phoneTextField.text!, password: passwordTextField.text!)

    }
    
    @IBAction func googleButton(_ sender: UIButton) {
        self.showAlertWith(message: "This feature is not available")
    }
    
    @IBAction func loginButton(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
//        guard presentor!.isTextFieldValid(name: nameTextField.text!, email: emailTextField.text!, password: passwordTextField.text!) else { return }
    }


}
extension SignUpViewController: SignUpView {
    func signUpSuccessfully(_ message: String) {
        self.showAlertWithObject(message: message) {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func showAlert(_ message: String) {
        self.showAlertWith(message: message)

    }

}
