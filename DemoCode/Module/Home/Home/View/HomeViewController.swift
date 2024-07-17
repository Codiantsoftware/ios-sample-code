//
//  HomeViewController.swift
//  DemoCode
//
//  Created by codiant on 26/02/24.
//


import UIKit

class HomeViewController: UIViewController {

    // MARK: - Instance Variables
    var router: HomeRouterProtocol!
    private lazy var presenter = {
      return HomePresenter(self)
    }()
    
    //MARK: - IBOutlets
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.configure()

    }
    
    //MARK: - Initial Setup
    
    func configure() {
        presenter.getUserDetail()
    }
    
    @IBAction func logoutButton(_ sender: UIButton) {
        Alert.showAlertWithMessageCallback(title: "DEMO",
                                           message: "Are you sure you want to logout",
                                           actionArray: ["CANCEL", "LOGOUT"],
                                           style: .alert,
                                           handler: { (action) in
          
          switch action.title {
          case "LOGOUT":
            self.presenter.logout()
            
          default:
            break
          }
        })
    }
    
    func setRootLogin() {
        let viewController = StoryboardScene.Account.instantiateViewController(withClass: LoginViewController.self)
        navigationController?.pushViewController(viewController, animated: false)

    }

}
extension HomeViewController: HomeView {
    func logoutSuccess() {
        Authorization.shared.clearSession()
        self.setRootLogin()

    }
    
    func showUserInfo(data: UserDetailsModel) {        
        firstNameLabel.text = data.firstName
        lastNameLabel.text = data.lastName
        emailLabel.text = data.email
        phoneLabel.text = data.phoneNumber
    }
    
    func showAlert(_ message: String) {
        if message.contains("Your session is expired. Please login again") {
            self.showAlertWithConfirmation(message: "Your session is expired. Please login again") {
                self.setRootLogin()
                Authorization.shared.clearSession()
            }
        } else {
            self.showAlertWith(message: message)
        }

    }

}
