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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupView()
    }
    
    private func setupView() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        self.view.addGestureRecognizer(gestureRecognizer)
        
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
