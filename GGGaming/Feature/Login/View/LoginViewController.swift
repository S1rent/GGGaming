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
    
    let viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupView()
        self.bindUI()
    }
    
    private func bindUI() {
        let output = viewModel.transform(input: LoginViewModel.Input(
            loginTrigger: self.buttonLogin.rx.tap.asDriver().throttle(RxTimeInterval.seconds(1)),
            emailRelay: self.emailField.rx.text.orEmpty.asDriver().debounce(RxTimeInterval.milliseconds(500)),
            passwordRelay: self.passwordField.rx.text.orEmpty.asDriver().debounce(RxTimeInterval.milliseconds(500))
        ))
        
        self.rx.disposeBag.insert(
            output.success.drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                let viewController = UINavigationController(rootViewController: HomeTabBarViewController())
                viewController.isNavigationBarHidden = false
                let delegate = self.view.window?.windowScene?.delegate as? SceneDelegate
                delegate?.setRootViewController(viewController: viewController)
            }),
            output.error.drive(onNext: { [weak self] message in
                guard let self = self else { return }
                
                self.showErrorPopup(message)
            })
        )
    }
    
    private func setupView() {
        let session = UserService.shared.getUser()
        if session?.userID != nil && !(session?.userID?.isEmpty ?? true) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) { [weak self] in
                guard let self = self else { return }
                
                let viewController = UINavigationController(rootViewController: HomeTabBarViewController())
                viewController.isNavigationBarHidden = false
                let delegate = self.view.window?.windowScene?.delegate as? SceneDelegate
                delegate?.setRootViewController(viewController: viewController)
            }
        } else {
            self.coverView.animateFadeOut()
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
    
    private func showErrorPopup(_ message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
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
