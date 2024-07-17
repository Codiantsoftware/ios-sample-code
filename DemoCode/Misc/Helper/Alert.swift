//
//  Codiant iOS
// Alert
//  Created by Codiant iOS on 19/01/2023.

import Foundation
import UIKit

struct Alert {
  // swiftlint:disable identifier_name
  var title: String?
  var message: String?
  var handler: (() -> Void)?
  
  init(title: String? = "PRODUCT_NAME", message: String?) {
    self.title = title
    self.message = message
  }
  
  init(title: String? = "PRODUCT_NAME", message: String?, handler: (() -> Void)? = nil) {
    self.title = title
    self.message = message
    self.handler = handler
  }
  
  static func network() -> Alert {
    return self.init(title: "PRODUCT_NAME",
                     message: "Please check internet connection")
  }
  
  static func showNetWorkAlert(handler:(() -> Void)? = nil) {
    showAlertWithMessage("Please check internet connection",
                         title: "Demo",
                         handler: handler)
  }
  
  func showAlertWithObject(message: String) -> UIAlertController {
    var viewController: UIViewController!
    if let vc = UIApplication.topViewController() {
      if vc.isKind(of: UIAlertController.self) {
        return UIAlertController()
      } else {
        viewController = vc
      }
    } else {
        viewController = appDelegate.window?.rootViewController!
    }
    
    let alertController = UIAlertController(title: "PRODUCT_NAME", message: message, preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (_) in
      self.handler?()
    }))
    viewController!.present(alertController, animated: true, completion: nil)
    return alertController
  }
  
  static func showAlertWithMessage(_ message: String, title: String?, handler:(() -> Void)? = nil) {
    //** If any Alert view is alrady presented then do not show another alert
    var viewController: UIViewController!
    if let vc = UIApplication.topViewController() {
      if vc.isKind(of: UIAlertController.self) {
        return
      } else {
        viewController = vc
      }
    } else {
        viewController = appDelegate.window?.rootViewController!
    }
    
    let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: { (_) in
      handler?()
    }))
    viewController!.present(alert, animated: true, completion: nil)
  }
  
  static func showAlertWithMessageCallback(title: String?, message: String?, actionArray: [String], style: UIAlertController.Style, handler: ((UIAlertAction) -> Void)? = nil) {
    
    //** If any Alert view is alrady presented then do not show another alert
    var viewController: UIViewController!
    if let vc  = UIApplication.topViewController() {
      if vc.isKind(of: UIAlertController.self) {
        return
      } else {
        viewController = vc
      }
    } else {
        viewController = appDelegate.window?.rootViewController!
    }
    
    let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
    
    for i in actionArray {
      
      alertController.addAction(UIAlertAction(title: i,
                                              style: (i == "Cancel" || i == "No") ?
                                                .cancel : ((i == "YES" || i == "LOGOUT")  ?
                                                  .destructive : .default),
                                              handler: { (action) in
                                                handler?(action)
      }))
      
    }
    
    viewController!.present(alertController, animated: true, completion: nil)
  }
  
  static func showConfirmationAlertWith(message: String, handler: (() -> Void)? = nil ,cancelButtonCallback: (() -> Void)? = nil) {
    var viewController: UIViewController!
    if let vc = UIApplication.topViewController() {
      if vc.isKind(of: UIAlertController.self) {
        return
      } else {
        viewController = vc
      }
    } else {
      viewController = appDelegate.window?.rootViewController!
    }
    
    let alert = UIAlertController(title: "PRODUCT_NAME", message: message, preferredStyle: UIAlertController.Style.alert)
    alert.addAction(UIAlertAction(title: "YES", style: UIAlertAction.Style.cancel, handler: { (_) in
      handler?()
    }))
    alert.addAction(UIAlertAction(title: "No", style: UIAlertAction.Style.default, handler: { (_) in
    }))
    viewController!.present(alert, animated: true, completion: nil)
  }
}

extension UIApplication {
  
  class func topViewController(_ base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
    if let nav = base as? UINavigationController {
      return topViewController(nav.visibleViewController)
    }
    if let tab = base as? UITabBarController {
      if let selected = tab.selectedViewController {
        return topViewController(selected)
      }
    }
    if let presented = base?.presentedViewController {
      return topViewController(presented)
    }
    return base
  }
  
}
