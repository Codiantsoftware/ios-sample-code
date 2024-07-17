//
//  LoginPresenter.swift
//  DemoCode
//
//  Created by codiant on 26/02/24.
//

import Foundation

protocol LoginInteractorToPresenter {
    func loginSuccess(_ message: String)
    func showError(_ message: String)
}

@objc protocol LoginView {
    func showAlert(_ message: String)
    func loginSuccess()
}

protocol LoginPresenterToInteractor {
  func login()
}

class LoginPresenter {
  
  weak private var delegate: LoginView?
var showPassword = false
    
  private lazy var interactor = {
    return LoginInteractor(self)
  }()
  
  init(_  delegate: LoginView) {
    self.delegate = delegate
  }
  
}

extension LoginPresenter {
    
    func login(email: String, password: String) {
        interactor.login(email: email, password: password)
    }
    
    func isTextFieldsValid(email: String, password: String) -> Bool {
        
        guard !(email.isEmpty) else {
            self.delegate?.showAlert("Please enter email")
            return false
        }
        
        guard email.isValid(type: .email) else {
          self.delegate?.showAlert("Please enter valid email")
          return false
        }
        
        guard !(password.isEmpty) else {
            self.delegate?.showAlert("Please enter password")
            return false
        }
        
        return true
    }
    
    
}

extension LoginPresenter: LoginInteractorToPresenter {
    func loginSuccess(_ message: String) {
        print("login scessully")
        delegate?.loginSuccess()
    }

    func showError(_ message: String) {
        print("error \(message)")
        delegate?.showAlert(message)
    }
    

}
