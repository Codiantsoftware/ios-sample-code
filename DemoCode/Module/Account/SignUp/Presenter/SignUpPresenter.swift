//
//  SignUpPresenter.swift
//  DemoCode
//
//  Created by codiant on 26/02/24.
//

import Foundation

protocol SignUpInteractorToPresenter {
    func signUpSuccess(_ message: String)
    func showError(_ message: String)
}

@objc protocol SignUpView {
    func showAlert(_ message: String)
    func signUpSuccessfully(_ message: String)
}

protocol SignUpPresenterToInteractor {
  func login()
}

class SignUpPresenter {
  
  weak private var delegate: SignUpView?
var showPassword = false
    
  private lazy var interactor = {
    return SignUpInteractor(self)
  }()
  
  init(_  delegate: SignUpView) {
    self.delegate = delegate
  }
  
}

extension SignUpPresenter {
    
    func signUp(firstName: String, lastName: String, email: String, phone: String, password: String) {
        interactor.signUp(firstName: firstName, lastName: lastName, email: email, phone: phone, password: password)
    }
    
    func isTextFieldsValid(firstName: String, lastName: String, email: String, phone: String, password: String) -> Bool {
        
        guard !(firstName.isEmpty) else {
            self.delegate?.showAlert("Please enter first name")
            return false
        }
        
        guard !(lastName.isEmpty) else {
            self.delegate?.showAlert("Please enter last name")
            return false
        }
        
        guard !(email.isEmpty) else {
            self.delegate?.showAlert("Please enter email")
            return false
        }
        
        guard email.isValid(type: .email) else {
          self.delegate?.showAlert("Please enter valid email")
          return false
        }
        
        guard !(phone.isEmpty) else {
            self.delegate?.showAlert("Please enter phone number")
            return false
        }
        
        guard !(password.isEmpty) else {
            self.delegate?.showAlert("Please enter password")
            return false
        }
        
        guard password.isValid(type: .password) else {
          self.delegate?.showAlert("Please enter strong password")
          return false
        }
        
        return true
    }
    
}

extension SignUpPresenter: SignUpInteractorToPresenter {
    func signUpSuccess(_ message: String) {
        print("signup scessully")
        delegate?.signUpSuccessfully(message)
    }
    
    func showError(_ message: String) {
        print("error \(message)")
        delegate?.showAlert(message)
    }
    

}
