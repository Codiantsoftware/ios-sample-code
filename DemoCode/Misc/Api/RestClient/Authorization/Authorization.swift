//
//  Authorization.swift
//  Codiant iOS
//
//  Created by codiant iOS on 26/02/2024.
//  Copyright © 2020 Codiant Software Technologies Pvt ltd. All rights reserved.
//

import Foundation
import JWTDecode
import KeychainAccess

// swiftlint:disable identifier_name
private let KEY_SKIP_LOGIN = "KEY_SKIP_LOGIN"
private let KEYCHAIN_ID = "KEYCHAIN_ID"

enum AuthorizationError: Error {
  case tokenNotExist
}

class Authorization {

  var jwt: String!
  var expiration: TimeInterval!
  var userCredentials: UserCredentials!

  var isGuest: Bool {
    get {
      UserDefaults.standard.bool(forKey: KEY_SKIP_LOGIN)
    }

    set {
      UserDefaults.standard.set(newValue, forKey: KEY_SKIP_LOGIN)
    }
  }

  private var keychain: Keychain!

  static let shared: Authorization = {
    var instance = Authorization()
    instance.keychain = Keychain(service: Bundle.main.bundleIdentifier!)
    return instance
  }()

    func authorize(jwt: String, data: [String: Any]) throws {
        self.jwt = jwt

        // Store token credentials in keychain
        self.saveToken(jwt)

        // Extract user information
        self.userCredentials = UserCredentials(JSON: data)

        // Store user information in keychain
        self.saveUser(self.userCredentials.toJSON())
//
//    do {
//      // Decode jwt token
////      let decodedJwt = try decode(jwt: jwt)
////
////      // Extract token expire time interval
////      self.expiration = decodedJwt.claim(name: "exp").rawValue as? Double ?? 0
////
////      // Validate expiration date
////      try self.verifyExpirationDate()
//
//
//      self.isGuest = false
//
//    } catch {
//      throw error
//    }
  }

  func restoreAuthorization() throws {

    self.retrieveToken()

    guard self.jwt != nil else {
      throw AuthorizationError.tokenNotExist
    }
     self.retrieveUser()
  }

  func synchronize() {
     self.saveUser(self.userCredentials.toJSON())
  }

  func clearSession() {
    try? self.keychain.removeAll()
    UserDefaults.standard.removeObject(forKey: KEYCHAIN_ID)
  }
}

// MARK: - Keychain access

extension Authorization {
  
  private func saveToken(_ token: String) {
    keychain[string: "jwt"] = token
    // keychain[string: "exp"] = String(exp)
  }
  
  private func saveUser(_ payload: [String: Any]) {
    
    do {
      let data = try JSONSerialization.data(withJSONObject: payload, options: .prettyPrinted)
      try keychain.set(data, key: "user")
      UserDefaults.standard.set(keychain.service, forKey: KEYCHAIN_ID)
    } catch {
     // log_debug("Error in saving user information in keychain", log: .default)
    }
  }
  
  private func retrieveToken() {
    if UserDefaults.standard.object(forKey: KEYCHAIN_ID) != nil {
      self.jwt = keychain[string: "jwt"]
      
      let exp = keychain[string: "exp"] ?? ""
      self.expiration = Double(exp) ?? 0
    } else {
      clearSession()
    }
  }
  
  private func retrieveUser() {
    guard let data = keychain[data: "user"] else {
      
     // log_debug("User data doesn't exist in keychain", log: .default)
      return
    }
    
    do {
      if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
        self.userCredentials = UserCredentials(JSON: json)
      }
      
    } catch {
     // log_debug("Error in retrieving user information from keychain", log: .default)
    }
  }
  
}
