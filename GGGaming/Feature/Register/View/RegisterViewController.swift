//
//  RegisterViewController.swift
//  GGGaming
//
//  Created by IT Division on 16/03/21.
//

import UIKit

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var registerView: UIView!
    @IBOutlet weak var buttonRegister: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupView()
    }
    
    private func setupView() {
        self.setupTextFieldDelegate()
        self.setupGestureRecognizer()
        self.setupCornerRadius()
    }
    
    private func setupTextFieldDelegate() {
        self.nameField.delegate = self
        self.emailField.delegate = self
        self.passwordField.delegate = self
    }
    
    private func setupGestureRecognizer() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        self.view.addGestureRecognizer(gestureRecognizer)
    }
    
    private func setupCornerRadius() {
        self.registerView.layer.cornerRadius = 6
        self.buttonRegister.layer.cornerRadius = 6
    }
    
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            let viewController = LoginViewController()
            
            let delegate = self.view.window?.windowScene?.delegate as? SceneDelegate
            delegate?.setRootViewController(viewController: viewController)
        }
    }
}

extension RegisterViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
