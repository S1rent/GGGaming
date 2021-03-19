//
//  ProfileAddSkillPopUpViewController.swift
//  GGGaming
//
//  Created by IT Division on 19/03/21.
//

import UIKit
import RxSwift
import RxCocoa

class ProfileAddSkillPopUpViewController: UIViewController {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var buttonAdd: UIButton!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var progressField: UITextField!
    @IBOutlet weak var progressView: UIProgressView!
    
    let addCallback: ((_ name: String, _ progressValue: String, _ type: ProfileAddItemEnum) -> Void)
    let type: ProfileAddItemEnum
    
    var name = ""
    var progressValue = ""
    
    init(
        addCallback: @escaping (_ name: String, _ progressValue: String, _ type: ProfileAddItemEnum) -> Void,
        type: ProfileAddItemEnum
    ) {
        self.addCallback = addCallback
        self.type = type
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupGestureRecognizer()
        self.setupView()
        self.bindUI()
    }
    
    private func bindUI() {
        self.rx.disposeBag.insert(
            self.nameField.rx.text.asDriverOnErrorJustComplete().debounce(RxTimeInterval.milliseconds(100)).drive(onNext: { [weak self] text in
                guard let self = self else { return }
                
                self.name = text ?? ""
            }),
            self.progressField.rx.text.asDriverOnErrorJustComplete().debounce(RxTimeInterval.milliseconds(300)).drive(onNext: { [weak self] text in
                guard let self = self else { return }
                
                self.progressValue = text ?? ""
                self.animateProgress(text ?? "")
            })
        )
    }
    
    private func setupView() {
        self.popUpView.layer.cornerRadius = 6
        self.buttonAdd.layer.cornerRadius = 6
        
        self.popUpView.layer.borderWidth = 2
        self.popUpView.layer.borderColor = UIColor.white.cgColor
        
        self.progressField.layer.cornerRadius = 6
        self.progressView.layer.cornerRadius = 6
    }
    
    private func setupGestureRecognizer() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        self.view.addGestureRecognizer(gestureRecognizer)
    }
    
    private func animateProgress(_ text: String) {
        let floatValue = Float(text) ?? 0
        if floatValue > 0 && floatValue <= 100 {
            self.progressView.setProgress(Float(floatValue / 100), animated: true)
            self.progressField.layer.borderColor = UIColor.clear.cgColor
            self.progressField.layer.borderWidth = 0
        } else {
            self.progressField.layer.borderColor = UIColor.red.cgColor
            self.progressField.layer.borderWidth = 2
        }
    }
    
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    @IBAction func backgroundTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addTapped(_ sender: Any) {
        self.addCallback(self.name, self.progressValue, self.type)
    }
}
