//
//  AuthorizationFilter.swift
//  Codiant iOS
//
//  Created by codiant iOS on 26/02/2024.
//  Copyright © 2020 Codiant Software Technologies Pvt ltd. All rights reserved.
//

import Foundation

enum AuthorizationFilterError: LocalizedError {
    case tokenExpired
    
    var errorDescription: String? {
        switch self {
        case .tokenExpired:
            return "Your session is expired, please login to continue."
        }
    }
}

// MARK: - Request filter

class AuthorizationFilter: HTTPRequestFilter {
    
    func filter(request: inout HTTPRequest) throws {
        if request.authorizationPolicy == .signedIn {
            request.setValue("Bearer \(Authorization.shared.jwt ?? "")", forHTTPHeaderField: "Authorization")

        } else {


        }
        
        NetworkLogger.log(httpRequest: request)
    }
}

// MARK: - Response filter

extension AuthorizationFilter: HTTPResponseFilter {
    func filter(response: inout HTTPResponse) throws {
        print("respone")
        NetworkLogger.log(httpResponse: response)
        switch response.statusCode {
        case .unauthorized:
            if UserDefaults.standard.object(forKey: "KEYCHAIN_ID") != nil {
                handleUnauthorization(response)
            }
        case .internalServerError:
            print("Internal deleted")

//             Alert.showAlertWithMessage("Internal Server Error", title: "PRODUCT_NAME".localize()) {
//           }
        case .forceUpdate:
            print("Force update")
//            handleForceUpdate()
        case .accountDeleted:
            print("account deleted")
//            Alert.showAlertWithMessage("Account deleted successfully", title: "PRODUCT_NAME".localize()) {
//                appDelegate.setLoginRoot()
//            }
        default:
            break
        }
    }
}

extension AuthorizationFilter {
    
    private func handleUnauthorization(_ response: HTTPResponse) {
        
        if let message = response.error() {
            if UserDefaults.standard.object(forKey: "KEYCHAIN_ID") != nil {
//                Alert.showAlertWithMessage(message, title: "PRODUCT_NAME".localize()) {
//                    Authorization.shared.userCredentials = UserCredentials()
//                    Authorization.shared.clearSession()
//                    Authorization.shared.synchronize()
//                    appDelegate.setLoginRoot()
//                }
            }
        }
    }
    
}
