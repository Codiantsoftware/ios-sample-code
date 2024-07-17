//
//  String.swift
//  Codiant iOS
//  Created by Codiant iOS on 19/01/2023.
//

import Foundation
import UIKit

enum RegexType {
  case email
  case name
  case phone
  case fullName
  case password
  
  func getRegex() -> String {
    switch self {
    case .name:
      return "[A-Z a-z ء-ي]{1,20}" //any characters maximum 20
    case .fullName:
      return "[a-z A-Z ]{1,20}"
    case .email:
      return "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    case .phone :
      return "[\\d]{6,15}" //mobile number validation 11 digits
    case .password:
      return "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{6,}$"

    }
  }
}

extension String {
  func localize() -> String {
    
    return NSLocalizedString(self, comment: "")
  }
  
  func isValid(type: RegexType) -> Bool {
    let regex = type.getRegex()
    let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
    return predicate.evaluate(with: self)
  }
  
  var formettedNumber: String {
    var formattedString: String = ""
    var counter = 0
    let firstStop: Int?
    let secondStop: Int?
    
    switch self.count {
    case 9 :
      firstStop = 2
      secondStop = (firstStop ?? 0) + 3
    case 10 :
      firstStop = 3
      secondStop = (firstStop ?? 0) + 3
    case 11 :
      firstStop = 3
      secondStop = (firstStop ?? 0) + 4
    default:
      firstStop = 4
      secondStop = (firstStop ?? 0) + 4
    }
    self.forEach { (char) in
      if firstStop == counter || secondStop == counter {
        formattedString.append(" \(char)")
      } else {
        formattedString.append(char)
      }
      counter += 1
    }
    return formattedString
  }

}


