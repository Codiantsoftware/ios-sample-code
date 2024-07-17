//
//  HomePresenter.swift
//  DemoCode
//
//  Created by codiant on 26/02/24.
//

import Foundation

protocol HomeInteractorToPresenter {
    func showError(_ message: String)
    func UserData(_ data: UserDetailsModel)
    func logoutSuccess()
}

 protocol HomeView {
    func showAlert(_ message: String)
    func showUserInfo(data: UserDetailsModel)
    func logoutSuccess()
}

protocol HomePresenterToInteractor {
  func login()
}

class HomePresenter {
  
private var delegate: HomeView?
var showPassword = false

  private lazy var interactor = {
    return HomeInteractor(self)
  }()
  
  init(_  delegate: HomeView) {
    self.delegate = delegate
  }
  
}

extension HomePresenter {
    
    func getUserDetail() {
        interactor.getUserDetail()
    }
    
    func logout() {
        interactor.logout()
    }
    
    func isTextFieldsValid(email: String, password: String) -> Bool {
        
        guard !(email.isEmpty) else {
            self.delegate?.showAlert("Please enter email")
            return false
        }
        
        guard !(password.isEmpty) else {
            self.delegate?.showAlert("Please enter password")
            return false
        }
        
        return true
    }
    
}

extension HomePresenter: HomeInteractorToPresenter {
    func logoutSuccess() {
        self.delegate?.logoutSuccess()
    }
    
    func UserData(_ data: UserDetailsModel) {
        print("user info -> \(data)")
        self.delegate?.showUserInfo(data: data)
    }

    func showError(_ message: String) {
        print("error \(message)")
        delegate?.showAlert(message)
    }
    

}
