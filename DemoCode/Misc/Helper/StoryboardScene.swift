//
//  StoryboardScene.swift
//  DemoCode
//
//  Created by codiant on 26/02/24.
//

import Foundation
import UIKit

class StoryboardScene {
  
  static let Home: UIStoryboard = {
    return UIStoryboard(name: "Home", bundle: nil)
  }()
  
  static let Account: UIStoryboard = {
    return UIStoryboard(name: "Main", bundle: nil)
  }()
  
  static let Setting: UIStoryboard = {
    return UIStoryboard(name: "Setting", bundle: nil)
  }()
  
  static let Splash: UIStoryboard = {
    return UIStoryboard(name: "Splash", bundle: nil)
  }()
  
  static let Profile: UIStoryboard = {
    return UIStoryboard(name: "Profile", bundle: nil)
  }()
  
}

extension UIStoryboard {
  func controllerExists(withIdentifier: String) -> Bool {
    if let availableIdentifiers = self.value(forKey: "identifierToNibNameMap") as? [String: Any] {
      return availableIdentifiers[withIdentifier] != nil
    }
    
    return false
  }
  
  func instantiateViewController<T>(withClass: T.Type) -> T {
    let identifier = NSStringFromClass((withClass as? AnyClass)!)
    let identifierValue = identifier.components(separatedBy: ".")[1]
    guard self.controllerExists(withIdentifier: identifierValue) else {
      fatalError("Failed to instantiate viewController")
    }
    
    return (self.instantiateViewController(withIdentifier: identifierValue) as? T)!
  }
  
}
