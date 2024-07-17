//
//  AccountWorker.swift
//  Codiant
//  Created by Codiant iOS on 26/02/2024.
//

import Foundation


struct AccountWorker {
  
  // MARK: - Login
  static func login(email: String,
                    password: String,
                    result: @escaping HTTPResult) {
    
    let parameters: HTTPParameters = ["emailOrMobile": email,
                                      "password": password,
                                      "deviceType": "ios"]
    
    do {
      let request = try HTTPRequest(uri: "login",
                                    method: .post,
                                    authorizationPolicy: .anonymous,
                                    parameterBuilder: .request(parameters: parameters), encoding: .json)
      let task = RequestTask(request: request, resultHandler: result)
      task.perfom()
    } catch {
      result(.failure(error))
    }
  }
  
  // MARK: - Signup API
  static func signup(firstName: String,
                     lastName: String,
                     phoneNumber: String,
                     email: String,
                     password: String,
                     confirmPassword: String,
                     result: @escaping HTTPResult) {
    
    let parameters: HTTPParameters = [
      "firstName": firstName,
      "lastName": lastName,
      "phoneNumber": phoneNumber,
      "email": email,
      "password": password,
      "confirmPassword": confirmPassword]
    
      do {
        let request = try HTTPRequest(uri: "signup",
                                      method: .post,
                                      authorizationPolicy: .anonymous,
                                      parameterBuilder: .request(parameters: parameters), encoding: .json)
        let task = RequestTask(request: request, resultHandler: result)
        task.perfom()
      } catch {
        result(.failure(error))
      }
  }
    
    // MARK: - User details
    static func userDetail(result: @escaping HTTPResult) {
      
        let parameters: HTTPParameters = [:]
      
      do {
        let request = try HTTPRequest(uri: "account/me",
                                      method: .get,
                                      authorizationPolicy: .signedIn,
                                      parameterBuilder: .request(parameters: parameters), encoding: .url)
        let task = RequestTask(request: request, resultHandler: result)
        task.perfom()
      } catch {
        result(.failure(error))
      }
    }
    
    // MARK: - Logout
    static func logout(result: @escaping HTTPResult) {
      
        let parameters: HTTPParameters = [:]
      
      do {
        let request = try HTTPRequest(uri: "logout",
                                      method: .get,
                                      authorizationPolicy: .signedIn,
                                      parameterBuilder: .request(parameters: parameters), encoding: .url)
        let task = RequestTask(request: request, resultHandler: result)
        task.perfom()
      } catch {
        result(.failure(error))
      }
    }
}


