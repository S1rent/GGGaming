//
//  ProfileViewController.swift
//  GGGaming
//
//  Created by IT Division on 11/03/21.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    @IBOutlet weak var educationStackView: UIStackView!
    @IBOutlet weak var educationInitView: UIView!
    
    @IBOutlet weak var workingExperienceStackView: UIStackView!
    @IBOutlet weak var workingExperienceInitView: UIView!
    @IBOutlet weak var skillStackView: UIStackView!
    @IBOutlet weak var skillInitView: UIView!
    @IBOutlet weak var logoutView: UIView!
    @IBOutlet weak var buttonLogout: UIButton!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView! {
        didSet {
            self.activityIndicator.isHidden = true
            self.activityIndicator.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            self.activityIndicator.color = UIColor.black
            self.activityIndicator.backgroundColor = UIColor.white
            self.activityIndicator.layer.cornerRadius = 6
            self.activityIndicator.snp.makeConstraints { make in
                make.height.equalTo(50)
                make.width.equalTo(50)
            }
        }
    }
    
    private lazy var noResultView: UILabel = {
        let label = UILabel()
        label.text = "No Data"
        label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.view.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        return label
    }()
    
    let viewModel: ProfileViewModel
    let loadRelay: BehaviorRelay<Void>
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        self.loadRelay = BehaviorRelay<Void>(value: ())
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Profile"
        
        self.setupView()
        self.bindUI()
    }

    private func bindUI() {
        let output = self.viewModel.transform(input: ProfileViewModel.Input(
            loadTrigger: self.loadRelay.asDriver()
        ))
        
        self.rx.disposeBag.insert(
            output.data.drive(onNext: { [weak self] data in
                guard let self = self else { return }
                
                self.setupData(data)
            })
        )
    }
    
    private func setupData(_ data: ProfileModel) {
        print("TESTING \(data)")
        self.imageProfile.sd_setImage(with: URL(string: data.picture), placeholderImage: UIImage(systemName: "person"))
        self.labelName.text = data.name
        self.labelEmail.text = data.email
        
        self.setupExperienceStackViewData(stackView: self.educationStackView, experienceList: data.educationList)
        self.setupExperienceStackViewData(stackView: self.workingExperienceStackView, experienceList: data.workingExperienceList)
        self.setupSkillStackViewData(stackView: self.skillStackView, skills: data.skills)
        
        if imageProfile.image == UIImage(systemName: "person") {
            self.imageProfile.layer.cornerRadius = 0
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            guard let self = self else { return }
            self.setActivityIndicator(loading: false)
        }
    }
    
    private func setupExperienceStackViewData(stackView: UIStackView, experienceList: [Experience]) {
        
        for (index, experience) in experienceList.enumerated() {
            let experienceItem = ExperienceItemView()
            
            experienceItem.labelDuration.text = experience.timeSpan
            experienceItem.labelDescription.text = experience.institutionName
            
            stackView.addArrangedSubview(experienceItem)
            
            if index != experienceList.count-1 {
                let separatorView = addSeparatorView()
                
                stackView.addArrangedSubview(separatorView)
                separatorView.snp.makeConstraints { make in
                    make.height.equalTo(0.75)
                    make.leading.equalToSuperview().offset(8)
                    make.trailing.equalToSuperview().offset(-8)
                }
            }
        }
    }
    
    private func setupSkillStackViewData(stackView: UIStackView, skills: [Skill]) {

        for (index, skill) in skills.enumerated() {
            let skillItem = SkillItemView()
            
            skillItem.labelSkillName.text = skill.skillName
            skillItem.progressView.progress = Float(skill.progress / 100)
            
            stackView.addArrangedSubview(skillItem)
            
            if index != skills.count-1 {
                let separatorView = addSeparatorView()
                
                stackView.addArrangedSubview(separatorView)
                separatorView.snp.makeConstraints { make in
                    make.height.equalTo(0.75)
                    make.leading.equalToSuperview().offset(8)
                    make.trailing.equalToSuperview().offset(-8)
                }
            }
        }
    }
    
    private func setupView() {
        self.imageProfile.layer.cornerRadius = self.imageProfile.frame.width / 2
        self.logoutView.layer.cornerRadius = 6
        self.buttonLogout.layer.cornerRadius = 6
        
        self.setupStackView(stackView: self.educationStackView)
        self.setupStackView(stackView: self.workingExperienceStackView)
        self.setupStackView(stackView: self.skillStackView)
        
        self.setActivityIndicator(loading: true)
    }
    
    private func setupStackView(stackView: UIStackView) {
        stackView.safelyRemoveAllArrangedSubviews()
        stackView.layer.cornerRadius = 6
        stackView.layer.borderColor = UIColor.white.cgColor
        stackView.layer.borderWidth = 0.7
        
        stackView.alpha = 0
        stackView.animateFadeIn()
    }
    
    private func setActivityIndicator(loading: Bool) {
        if loading {
            self.activityIndicator.animateFadeIn()
            self.activityIndicator.startAnimating()
        } else {
            self.activityIndicator.animateFadeOut()
            self.activityIndicator.stopAnimating()
        }
    }
    
    private func addSeparatorView() -> UIView {
        let view = UIView()
        view.backgroundColor = UIColor.white
        
        return view
    }
    
    private func presentInformation() {
        let alertController = UIAlertController(title: "Information", message: "Successfully logged out.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            
            UserService.shared.deleteUserSession()
            let viewController = LoginViewController()
            let delegate = self.view.window?.windowScene?.delegate as? SceneDelegate
            delegate?.setRootViewController(viewController: viewController)
        })
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func showLogoutPopupConfirmation() {
        let alertController = UIAlertController(title: "Confirmation", message: "Are you sure you want logout ?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            
            self.presentInformation()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        UIApplication.topViewController()?.navigationController?.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func logoutTapped(_ sender: Any) {
        self.showLogoutPopupConfirmation()
    }
}
