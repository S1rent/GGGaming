//
//  RegisterViewController.swift
//  GGGaming
//
//  Created by IT Division on 16/03/21.
//

import UIKit
import RxCocoa
import RxSwift

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var registerView: UIView!
    @IBOutlet weak var buttonRegister: UIButton!
    
    let viewModel: RegisterViewModel
    let loadRelay: BehaviorRelay<Void>
    
    init() {
        self.viewModel = RegisterViewModel()
        self.loadRelay = BehaviorRelay<Void>(value: ())
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupView()
        self.bindUI()
    }
    
    private func bindUI() {
        let output = viewModel.transform(input: RegisterViewModel.Input(
            submitTrigger: self.buttonRegister.rx.tap.asDriver().throttle(RxTimeInterval.seconds(1)),
            nameTrigger: self.nameField.rx.text.orEmpty.asDriver().debounce(RxTimeInterval.milliseconds(500)),
            emailTrigger: self.emailField.rx.text.orEmpty.asDriver().debounce(RxTimeInterval.milliseconds(500)),
            passwordTrigger: self.passwordField.rx.text.orEmpty.asDriver().debounce(RxTimeInterval.milliseconds(500))
        ))
        
        self.rx.disposeBag.insert(
            output.success.drive(onNext: { [weak self] success in
                guard let self = self else { return }
                
                self.showSuccessPopup(success)
            }),
            output.error.drive(onNext: { [weak self] error in
                guard let self = self else { return }
                
                self.showErrorPopup(error)
            })
        )
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
    
    private func showSuccessPopup(_ message: String) {
        let alertController = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            let viewController = UINavigationController(rootViewController: HomeTabBarViewController())
            viewController.isNavigationBarHidden = false
            let delegate = self.view.window?.windowScene?.delegate as? SceneDelegate
            delegate?.setRootViewController(viewController: viewController)
        })
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func showErrorPopup(_ message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
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
