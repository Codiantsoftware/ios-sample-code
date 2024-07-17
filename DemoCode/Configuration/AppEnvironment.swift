//
//  Environment.swift
//  Copyright © 2020 Codiant Software Technologies Pvt ltd. All rights reserved.
//

import Foundation

enum AppEnvironment {
  
  // MARK: - Identifier
  enum Identifier: String {
    case dev
    case staging
    case live
    case qa
  }
  
  // MARK: - Keys
  enum Keys {
    static let apiURL = "API_URL"
    static let envIdentifier = "ENV_IDF"
    static let appVersion = "APP_VERSION"
    static let socketURL = "SOCKET_URL"
    static let CFBundleShortVersionString = "CFBundleShortVersionString"
  }
  
  // MARK: - Plist
  private static let infoDictionary: [String: Any] = {
    guard let infoDictionary = Bundle.main.infoDictionary else {
      fatalError("Plist file not found")
    }
    
    return infoDictionary
  }()
  
  static let identifier: Identifier = {
    guard let envIdentifier = AppEnvironment.infoDictionary[Keys.envIdentifier] as? String else {
      fatalError("ENV_IDF Key not set in plist for this environment")
    }
    
    return Identifier(rawValue: envIdentifier)!
  }()
  
  static let apiURL: String = {
    guard let apiURL = AppEnvironment.infoDictionary[Keys.apiURL] as? String else {
      fatalError("API_URL Key not set in plist for this environment")
    }
    
    return apiURL
  }()

  static let appVersion: String = {
    guard let appVersionLocal = AppEnvironment.infoDictionary[Keys.CFBundleShortVersionString] as? String else {
      fatalError("APP_VERSION Key not set in plist for this environment")
    }
    print("App version test -> \(appVersionLocal)")
    return appVersionLocal
  }()
  
  static let socketURL: String = {
    guard let appVersionLocal = AppEnvironment.infoDictionary[Keys.socketURL] as? String else {
      fatalError("SOCKET_URL Key not set in plist for this environment")
    }
    
    return appVersionLocal
  }()
  
}
