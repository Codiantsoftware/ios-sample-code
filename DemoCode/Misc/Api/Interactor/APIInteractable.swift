//
//  APIInteractable.swift
//  Codiant iOS
//  Created by Codiant iOS on 19/01/2023.
//

import Foundation

struct APIInteractable {
    static let Account: AccountWorker.Type = {
        return AccountWorker.self
    }()

}
