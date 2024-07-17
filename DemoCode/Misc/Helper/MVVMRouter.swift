//
//  MVVMRouter.swift
//  DemoCode
//
//  Created by codiant on 26/02/24.
//

import Foundation
import UIKit

protocol MVVMRouter {
  func attach(with baseVC: UIViewController, context: Any?)
  func deattach()
  func enqueueRoute(with context: Any?)
}
