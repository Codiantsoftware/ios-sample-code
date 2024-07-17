//
//  AppDelegate.swift
//  DemoCode
//
//  Created by codiant on 26/02/24.
//

import UIKit
import IQKeyboardManagerSwift

let appDelegate = UIApplication.shared.delegate as! AppDelegate
let userDefault = UserDefaults.standard

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var navigationController: UINavigationController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupWindow()
        configureIQKeyboard()
        RestClient.shared.host = AppEnvironment.apiURL
        RestClient.shared.host = "https://node-api-demo.codiantdev.com/api/v1"
        RestClient.shared.requestFilter = AuthorizationFilter()
        RestClient.shared.responseFilter = AuthorizationFilter()

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {

        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {

    }

    func configureIQKeyboard() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldShowToolbarPlaceholder = false
        IQKeyboardManager.shared.shouldPlayInputClicks = true
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "DONE"
    }
    
    private func setupWindow() {
      navigationController = UINavigationController()
      navigationController?.isNavigationBarHidden = true
      window = UIWindow(frame: UIScreen.main.bounds)
      window!.rootViewController = navigationController
      window?.makeKeyAndVisible()
    }
    
    func rootConfiguration() {
        self.setSplashControllerRoot()
    }
    
    func setSplashControllerRoot() {
        let splashVC = LoginRouter().build()
        let navigationController = UINavigationController(rootViewController: splashVC)
        navigationController.navigationBar.isHidden = true
        navigationController.interactivePopGestureRecognizer?.isEnabled = false
        setRoot(viewController: navigationController)
    }
    
    func setRoot(viewController: UIViewController) {
      window?.rootViewController = nil
      window?.rootViewController = viewController
      window?.makeKeyAndVisible()
      UIView.transition(with: window!, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
    }
}

