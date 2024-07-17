//
//  LoginInteractor.swift
//  DemoCode
//
//  Created by codiant on 26/02/24.
//

import Foundation

class LoginInteractor {
    
    var delegate: LoginInteractorToPresenter?
    
    init(_  delegate: LoginInteractorToPresenter) {
        self.delegate = delegate
    }
    
    func login(email: String, password: String) {
        HudView.show()
        
        APIInteractable.Account.login(email: email, password: password) { [weak self] (result) in
            guard let `self` = self else { return }
            HudView.kill()
            switch result {
            case .success(let response):
                if let json = response.serverResponse as? HTTPParameters {
                    print("Json -> \(json)")
                    do {
                        let token = json["token"] as? String
                        try Authorization.shared.authorize(jwt: token ?? "", data: json)
                        Authorization.shared.synchronize()
                    } catch {
                    }
                }
                self.delegate?.loginSuccess(response.serverMessage as? String ?? "")

            case .failure(let error):
                self.delegate?.showError(error.localizedDescription)
                
            }
        }
    }
    
}
