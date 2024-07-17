//
//  UiViewController+Extension.swift
//  DemoCode
//
//  Created by codiant on 26/02/24.
//

import Foundation
import UIKit

extension UIViewController {
  
  func push(_ viewController: UIViewController, animated: Bool = true) {
    navigationController?.pushViewController(viewController, animated: animated)
  }
  
  func pop(animated: Bool = true) {
    navigationController?.popViewController(animated: animated)
  }
  
  func popToRoot(animated: Bool = true) {
     navigationController?.popToRootViewController(animated: animated)
   }
   
  func present(_ viewController: UIViewController, animated: Bool = true) {
    present(viewController, animated: animated, completion: nil)
  }
  
  func dismiss(animated: Bool = true) {
    dismiss(animated: animated, completion: nil)
  }
  
  func showAlertWith(message: String, cancelButtonCallback: (() -> Void)? = nil) {
    let alertController = UIAlertController(title: "DEMO", message: message, preferredStyle: .alert)
      alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
      cancelButtonCallback?()
    }))
    present(alertController, animated: true, completion: nil)
  }
  
  func showAlertWithObject(message: String, callback: (() -> Void)? = nil) -> UIAlertController {
     let alertController = UIAlertController(title: "DEMO", message: message, preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: { _ in
       callback?()
     }))
     present(alertController, animated: true, completion: nil)
    return alertController
   }
    
    func showAlertWithConfirmation(message: String, ok: (() -> Void)? = nil) {
       let alertController = UIAlertController(title: "PRODUCT_NAME", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
          ok?()
       }))
        alertController.addAction(UIAlertAction(title: "CANCEL", style: .cancel))
       present(alertController, animated: true, completion: nil)
     }
   
  func add(_ child: UIViewController, frame: CGRect? = nil) {
    addChild(child)
    if let frame = frame {
      child.view.frame = frame
    }
    view.addSubview(child.view)
    child.didMove(toParent: self)
  }
  
  func remove() {
    willMove(toParent: nil)
    view.removeFromSuperview()
    removeFromParent()
  }
  
  func present(_ viewController: UIViewController, animated: Bool = true, presentationStyle: UIModalPresentationStyle, transitionStyle: UIModalTransitionStyle) {
    DispatchQueue.main.async {
      viewController.modalPresentationStyle = presentationStyle
      viewController.modalTransitionStyle = transitionStyle
      self.present(viewController, animated: animated, completion: nil)
    }
  }
}
