//
//  HomeInteractor.swift
//  DemoCode
//
//  Created by codiant on 26/02/24.
//

import Foundation

class HomeInteractor {
    
    var delegate: HomeInteractorToPresenter?
    
    init(_  delegate: HomeInteractorToPresenter) {
        self.delegate = delegate
    }
    
    func getUserDetail() {
        HudView.show()

        APIInteractable.Account.userDetail() { [weak self] (result) in
            guard let `self` = self else { return }
            HudView.kill()
            switch result {
            case .success(let response):
                if let json = response.serverResponse as? HTTPParameters {
                    print("Json user -> \(json)")
                    if let data = UserDetailsModel(JSON: json) {
                        self.delegate?.UserData(data)

                    }
                }
                                
            case .failure(let error):
                self.delegate?.showError(error.localizedDescription)

            }
        }
    }
    
    func logout() {
        HudView.show()

        APIInteractable.Account.logout() { [weak self] (result) in
            guard let `self` = self else { return }
            HudView.kill()
            switch result {
            case .success(let response):
                if let json = response.serverResponse as? HTTPParameters {
                    print("Json user -> \(json)")
                }
                let msg = response.serverMessage as? String ?? ""
                print("msge logout - \(msg)")
                self.delegate?.logoutSuccess()
            case .failure(let error):
                self.delegate?.showError(error.localizedDescription)

            }
        }
    }

}
