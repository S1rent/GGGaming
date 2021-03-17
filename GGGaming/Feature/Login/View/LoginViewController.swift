//
//  LoginViewController.swift
//  GGGaming
//
//  Created by IT Division on 16/03/21.
//

import UIKit
import RxSwift
import RxCocoa

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var buttonLogin: UIButton!
    @IBOutlet weak var loginView: UIView!
    @IBOutlet weak var coverView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupView()
        self.buttonLogin.rx.tap.subscribe(onNext: { _ in
            let viewController = UINavigationController(rootViewController: HomeTabBarViewController())
            viewController.isNavigationBarHidden = false
            let delegate = self.view.window?.windowScene?.delegate as? SceneDelegate
            delegate?.setRootViewController(viewController: viewController)
        }).disposed(by: self.rx.disposeBag)
    }
    
    private func setupView() {
        let session = UserService.shared.getUserSession()
        if session.userID != nil || !(session.userID?.isEmpty ?? false) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) { [weak self] in
                guard let self = self else { return }
                let viewController = UINavigationController(rootViewController: HomeTabBarViewController())
                viewController.isNavigationBarHidden = false
                let delegate = self.view.window?.windowScene?.delegate as? SceneDelegate
                delegate?.setRootViewController(viewController: viewController)
            }
        }
        
        self.setupTextFieldDelegate()
        self.setupGestureRecognizer()
        self.setupCornerRadius()
    }
    
    private func setupTextFieldDelegate() {
        self.passwordField.delegate = self
        self.emailField.delegate = self
    }
    
    private func setupGestureRecognizer() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        self.view.addGestureRecognizer(gestureRecognizer)
    }
    
    private func setupCornerRadius() {
        self.buttonLogin.layer.cornerRadius = 6
        self.loginView.layer.cornerRadius = 6
    }
    
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    @IBAction func registerTapped(_ sender: Any) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            let viewController = RegisterViewController()
            
            let delegate = self.view.window?.windowScene?.delegate as? SceneDelegate
            delegate?.setRootViewController(viewController: viewController)
        }
    }
}

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
