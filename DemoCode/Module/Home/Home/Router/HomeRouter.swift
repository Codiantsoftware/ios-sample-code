//
//  HomeRouter.swift
//  DemoCode
//
//  Created by codiant on 26/02/24.
//

import UIKit
import Foundation

protocol HomeRouterProtocol: MVVMRouter {
    func build() -> UIViewController
}

class HomeRouter {
  enum RouteType {
  }
  
  weak var baseViewController: UIViewController?
}

extension HomeRouter: HomeRouterProtocol {
  
  func build() -> UIViewController {
    let viewController = StoryboardScene.Account.instantiateViewController(withClass: HomeViewController.self)
    viewController.router = self
    baseViewController = viewController
    
    return viewController
  }
  
  func attach(with baseVC: UIViewController, context: Any?) {
    let viewController = StoryboardScene.Account.instantiateViewController(withClass: HomeViewController.self)
    viewController.router = self
    baseViewController = viewController
    baseVC.push(viewController)
  }
  
  func deattach() {
    baseViewController?.pop()
    
  }
  
    func enqueueRoute(with context: Any?) {
        
        guard let routeType = context as? RouteType else {
            assertionFailure("The route type missmatches")
            return
        }
        
        guard let baseViewController = baseViewController else {
            assertionFailure("baseViewController is not set")
            return
        }
        
//        switch routeType {
//        case .signup:
//            let router = SignUpRouter()
//            router.attach(with: baseViewController, context: nil)
//            
//        }
    }
}
