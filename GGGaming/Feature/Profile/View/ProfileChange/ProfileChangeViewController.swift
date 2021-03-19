//
//  ProfileChangeViewController.swift
//  GGGaming
//
//  Created by IT Division on 19/03/21.
//

import UIKit
import RxSwift
import RxCocoa

class ProfileChangeViewController: UIViewController {
    
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var photoURLField: UITextField!
    @IBOutlet weak var buttonSave: UIButton!
    @IBOutlet weak var saveView: UIView!
    @IBOutlet weak var coverView: UIView!
    
    let viewModel: ProfileChangeViewModel
    let loadTrigger: BehaviorRelay<Void>
    
    init(viewModel: ProfileChangeViewModel) {
        self.viewModel = viewModel
        self.loadTrigger = BehaviorRelay<Void>(value: ())
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Change Profile"
        
        self.setupGestureRecognizer()
        self.setupView()
        self.bindUI()
    }
    
    private func bindUI() {
        
        let output = viewModel.transform(input: ProfileChangeViewModel.Input(
            loadTrigger: self.loadTrigger.asDriver(),
            nameRelay: self.nameField.rx.text.orEmpty.asDriver().debounce(RxTimeInterval.milliseconds(500)),
            emailRelay: self.emailField.rx.text.orEmpty.asDriver().debounce(RxTimeInterval.milliseconds(500)),
            urlRelay: self.photoURLField.rx.text.orEmpty.asDriver().debounce(RxTimeInterval.milliseconds(200)),
            saveTrigger: self.buttonSave.rx.tap.asDriver().throttle(RxTimeInterval.milliseconds(500))
        ))
        
        self.rx.disposeBag.insert(
            output.data.drive(onNext: { [weak self] data in
                guard let self = self,
                      let userData = data
                else { return }
                
                self.setupData(userData)
            }),
            output.success.drive(onNext: { [weak self] message in
                guard let self = self else { return }
                
                self.presentInformationPopup(title: "Success", message: message, callBack: {
                    UIApplication.topViewController()?.navigationController?.popViewController(animated: true)
                })
            }),
            output.error.drive(onNext: { [weak self] errorMessage in
                guard let self = self else { return }
                
                self.presentInformationPopup(title: "Error", message: errorMessage)
            }),
            self.photoURLField.rx.text.orEmpty.asDriver().debounce(RxTimeInterval.milliseconds(500)).drive(onNext: { [weak self] photoUrl in
                guard let self = self else { return }
                
                self.imageProfile.sd_setImage(with: URL(string: photoUrl), placeholderImage: UIImage(systemName: "person"))
            })
        )
    }
    
    private func setupData(_ data: AuthenticatedUser) {
        self.nameField.text = data.userName
        self.emailField.text = data.userEmail
        self.photoURLField.text = data.userPhotoURL
        
        self.imageProfile.sd_setImage(with: URL(string: data.userPhotoURL ?? ""), placeholderImage: UIImage(systemName: "person"))
    }
    
    private func setupView() {
        self.coverView.animateFadeOut()
        self.imageProfile.layer.cornerRadius = self.imageProfile.frame.width / 2
        self.buttonSave.layer.cornerRadius = 6
        self.saveView.layer.cornerRadius = 6
        
        self.setupTextField(emailField)
        self.setupTextField(nameField)
        self.setupTextField(photoURLField)
    }
    
    private func setupTextField(_ field: UITextField) {
        field.layer.borderColor = UIColor.white.cgColor
        field.layer.borderWidth = 1
        field.layer.cornerRadius = 6
        field.delegate = self
    }
    
    private func setupGestureRecognizer() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        self.view.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    @IBAction func buttonPasteTapped(_ sender: Any) {
        if let photoURL = UIPasteboard.general.string {
            self.photoURLField.text = photoURL
            self.imageProfile.sd_setImage(with: URL(string: photoURL), placeholderImage: UIImage(systemName: "person"))
            self.photoURLField.becomeFirstResponder()
        }
    }
}

extension ProfileChangeViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 2.5
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.layer.borderWidth = 1
    }
}
