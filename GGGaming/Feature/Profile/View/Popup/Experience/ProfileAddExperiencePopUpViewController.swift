//
//  ProfileAddExperiencePopUpViewController.swift
//  GGGaming
//
//  Created by IT Division on 18/03/21.
//

import UIKit
import RxSwift
import RxCocoa

class ProfileAddExperiencePopUpViewController: UIViewController {
    
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var buttonAdd: UIButton!
    @IBOutlet weak var experienceNameField: UITextField!
    @IBOutlet weak var termField: UITextField!
    
    let addCallback: ((_ name: String, _ term: String, _ type: ProfileAddItemEnum) -> Void)
    let type: ProfileAddItemEnum
    
    var name = ""
    var term = ""
    
    init(
        addCallback: @escaping (_ name: String, _ term: String, _ type: ProfileAddItemEnum) -> Void,
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
            self.experienceNameField.rx.text.asDriverOnErrorJustComplete().debounce(RxTimeInterval.milliseconds(100)).drive(onNext: { [weak self] text in
                guard let self = self else { return }
                
                self.name = text ?? ""
            }),
            self.termField.rx.text.asDriverOnErrorJustComplete().debounce(RxTimeInterval.milliseconds(100)).drive(onNext: { [weak self] text in
                guard let self = self else { return }
                
                self.term = text ?? ""
            })
        )
    }
    
    private func setupView() {
        self.popupView.layer.cornerRadius = 6
        self.buttonAdd.layer.cornerRadius = 6
        
        self.popupView.layer.borderWidth = 2
        self.popupView.layer.borderColor = UIColor.white.cgColor
    }
    
    private func setupGestureRecognizer() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        self.view.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    @IBAction func backgroundTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addItemTapped(_ sender: Any) {
        self.addCallback(self.name, self.term, self.type)
    }
}
