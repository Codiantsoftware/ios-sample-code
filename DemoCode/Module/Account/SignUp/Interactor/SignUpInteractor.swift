//
//  SignUpInteractor.swift
//  DemoCode
//
//  Created by codiant on 26/02/24.
//

import Foundation

class SignUpInteractor {
    
    var delegate: SignUpInteractorToPresenter?
    
    init(_  delegate: SignUpInteractorToPresenter) {
        self.delegate = delegate
    }
    
    func signUp(firstName: String, lastName: String, email: String, phone: String, password: String) {
        HudView.show()
        APIInteractable.Account.signup(firstName: firstName,
                                       lastName: lastName,
                                       phoneNumber: phone,
                                       email: email,
                                       password: password,
                                       confirmPassword: password) { [weak self] (result) in
            guard let `self` = self else { return }
            HudView.kill()
            switch result {
            case .success(let response):
                if let json = response.serverResponse as? HTTPParameters {
                    print("Json -> \(json)")
                }
                self.delegate?.signUpSuccess(response.serverMessage as? String ?? "")
                
            case .failure(let error):
                self.delegate?.showError(error.localizedDescription)
                
            }
        }
    }

}
