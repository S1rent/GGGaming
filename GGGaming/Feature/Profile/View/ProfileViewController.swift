//
//  ProfileViewController.swift
//  GGGaming
//
//  Created by IT Division on 11/03/21.
//  [IMPORTANT NOTE] -> Popup Function Is located In ProfileViewController+Extension

import UIKit
import RxSwift
import RxCocoa
import SnapKit

class ProfileViewController: UIViewController {
    
    // Education Outlet
    @IBOutlet weak var buttonAddEducation: UIButton!
    @IBOutlet weak var educationStackView: UIStackView!
    @IBOutlet weak var educationInitView: UIView!
    
    // Logout Outlet
    @IBOutlet weak var logoutView: UIView!
    @IBOutlet weak var buttonLogout: UIButton!
    
    // Profile Outlet
    @IBOutlet weak var imageProfile: UIImageView!
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelEmail: UILabel!
    
    // Skill Outler
    @IBOutlet weak var skillStackView: UIStackView!
    @IBOutlet weak var skillInitView: UIView!
    
    // Working Experience Outlet
    @IBOutlet weak var workingExperienceStackView: UIStackView!
    @IBOutlet weak var workingExperienceInitView: UIView!
    
    @IBOutlet weak var coverView: UIView!
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
    let loadRelay = BehaviorRelay<Void>(value: ())
    let navigator = ProfileNavigator.shared
    
    let addItemRelay = BehaviorRelay<Void>(value: ())
    
    let itemNameRelay = BehaviorRelay<String>(value: "")
    let itemTermRelay = BehaviorRelay<String>(value: "")
    let itemProgressValueRelay = BehaviorRelay<String>(value: "")
    let itemTypeRelay = BehaviorRelay<ProfileAddItemEnum>(value: .skill)
    
    var currentSkillItem: SkillItemView?
    var currentExperienceItem: ExperienceItemView?
    
    init(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Profile"
        
        self.setupRightBarItem()
        self.setupView()
        self.bindUI()
    }

    private func bindUI() {
        let willAppear = self.rx.sentMessage(#selector(UIViewController.viewWillAppear(_:))).mapToVoid().asDriverOnErrorJustComplete()
        
        let output = self.viewModel.transform(input: ProfileViewModel.Input(
            loadTrigger: Driver.merge(self.loadRelay.asDriver(), willAppear),
            itemName: itemNameRelay.asDriverOnErrorJustComplete(),
            itemTerm: itemTermRelay.asDriverOnErrorJustComplete(),
            itemProgressValue: itemProgressValueRelay.asDriverOnErrorJustComplete(),
            itemType: itemTypeRelay.asDriverOnErrorJustComplete(),
            addTrigger: addItemRelay.asDriverOnErrorJustComplete().skip(1)
        ))
        
        self.rx.disposeBag.insert(
            output.data.drive(onNext: { [weak self] data in
                guard let self = self else { return }
                
                self.coverView.alpha = 1
                self.coverView.animateFadeIn()
                self.setActivityIndicator(loading: true)
                self.setupData(data)
            }),
            output.addSuccess.drive(onNext: { [weak self] message in
                guard let self = self else { return }
                
                self.presentInformationPopup(title: "Success", message: message, callBack: self.refreshCallback)
            }),
            output.addError.drive(onNext: { [weak self] errorMessage in
                guard let self = self else { return }
                
                self.presentInformationPopup(title: "Error", message: errorMessage)
            })
        )
    }
    
    // data function
    private func setupData(_ data: ProfileModel) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            guard let self = self else { return }
            
            self.coverView.animateFadeOut()
            self.setActivityIndicator(loading: false)
        }
        
        self.skillStackView.safelyRemoveAllArrangedSubviews()
        self.educationStackView.safelyRemoveAllArrangedSubviews()
        self.workingExperienceStackView.safelyRemoveAllArrangedSubviews()
        
        self.imageProfile.sd_setImage(with: URL(string: data.picture), placeholderImage: UIImage(systemName: "person"))
        self.labelName.text = data.name
        self.labelEmail.text = data.email
        
        self.setupExperienceStackViewData(stackView: self.educationStackView, experienceList: data.educationList, type: ProfileAddItemEnum.education)
        self.setupExperienceStackViewData(stackView: self.workingExperienceStackView, experienceList: data.workingExperienceList, type: ProfileAddItemEnum.workingExperience)
        self.setupSkillStackViewData(stackView: self.skillStackView, skills: data.skills)
    }
    
    private func setupExperienceStackViewData(stackView: UIStackView, experienceList: [Experience], type: ProfileAddItemEnum) {
        
        if experienceList.isEmpty {
            self.setupNoDataItem(stackView)
        } else {
            self.setupExperienceItems(stackView, experienceList, type: type)
        }
    }
    
    private func setupSkillStackViewData(stackView: UIStackView, skills: [Skill]) {
        
        if skills.isEmpty {
            self.setupNoDataItem(stackView)
        } else {
            self.setupSkillItems(stackView, skills: skills)
        }
    }
    
    private func setupExperienceItems(_ stackView: UIStackView, _ experiences: [Experience], type: ProfileAddItemEnum) {
        for (index, experience) in experiences.enumerated() {
            let experienceItem = ExperienceItemView(
                callBack: self.setActiveExperienceItemView,
                data: experience,
                refreshCallback: self.pureRefreshCallback,
                type: type
            )
            
            experienceItem.labelDuration.text = experience.timeSpan
            experienceItem.labelDescription.text = experience.institutionName
            
            stackView.addArrangedSubview(experienceItem)
            
            experienceItem.snp.makeConstraints { make in
                make.leading.equalToSuperview()
                make.trailing.equalToSuperview()
            }
            
            if index != experiences.count-1 {
                self.addSeparatorView(stackView)
            }
        }
    }
    
    private func setupSkillItems(_ stackView: UIStackView, skills: [Skill]) {
        for (index, skill) in skills.enumerated() {
            let skillItem = SkillItemView(
                callBack: self.setActiveSkillItemView,
                data: skill,
                refreshCallback: self.pureRefreshCallback
            )
            
            skillItem.labelSkillName.text = skill.skillName
            skillItem.progressView.progress = Float(skill.progress / 100)
            
            stackView.addArrangedSubview(skillItem)
            
            skillItem.snp.makeConstraints { make in
                make.leading.equalToSuperview()
                make.trailing.equalToSuperview()
            }
            
            if index != skills.count-1 {
                self.addSeparatorView(stackView)
            }
        }
    }
    
    // IBAction function
    @IBAction func logoutTapped(_ sender: Any) {
        self.showLogoutPopupConfirmation()
    }
    
    @IBAction func addEducationTapped(_ sender: Any) {
        self.navigator.navigateToAddExperiencePopUp(callBack: self.addExperienceCallback, type: ProfileAddItemEnum.education)
    }
    
    @IBAction func addExperienceTapped(_ sender: Any) {
        self.navigator.navigateToAddExperiencePopUp(callBack: self.addExperienceCallback, type: ProfileAddItemEnum.workingExperience)
    }
    
    @IBAction func addSkillTapped(_ sender: Any) {
        self.navigator.navigateToAddSkillPopUp(callBack: self.addSkillCallback, type: ProfileAddItemEnum.skill)
    }
}

// Callback Function
extension ProfileViewController {
    func addExperienceCallback(name: String, term: String, type: ProfileAddItemEnum) {
        self.itemTermRelay.accept(term)
        self.notifyRelay(name: name, type: type)
    }
    
    func addSkillCallback(name: String, progressValue: String, type: ProfileAddItemEnum) {
        self.itemProgressValueRelay.accept(progressValue)
        self.notifyRelay(name: name, type: type)
    }
    
    func notifyRelay(name: String, type: ProfileAddItemEnum) {
        self.itemNameRelay.accept(name)
        self.itemTypeRelay.accept(type)
        self.addItemRelay.accept(())
    }
    
    func refreshCallback() {
        UIApplication.topViewController()?.dismiss(animated: true, completion: nil)
        self.loadRelay.accept(())
    }
    
    func pureRefreshCallback() {
        self.loadRelay.accept(())
    }
    
    func setActiveSkillItemView(_ item: SkillItemView) {
        if let activeItem = self.currentSkillItem {
            activeItem.buttonDelete.alpha = 0
            activeItem.buttonDelete.isUserInteractionEnabled = false
            activeItem.backgroundColor = UIColor.clear
        }
        
        if let activeExperienceItem = self.currentExperienceItem {
            activeExperienceItem.buttonDelete.alpha = 0
            activeExperienceItem.buttonDelete.isUserInteractionEnabled = false
            activeExperienceItem.backgroundColor = UIColor.clear
        }
        
        self.currentSkillItem = item
        
        if let activeItem = self.currentSkillItem {
            activeItem.buttonDelete.alpha = 1
            activeItem.buttonDelete.isUserInteractionEnabled = true
            activeItem.backgroundColor = UIColor.darkGray
        }
    }
    
    func setActiveExperienceItemView(_ item: ExperienceItemView) {
        if let activeItem = self.currentExperienceItem {
            activeItem.buttonDelete.alpha = 0
            activeItem.buttonDelete.isUserInteractionEnabled = false
            activeItem.backgroundColor = UIColor.clear
        }
        
        if let activeSkillItem = self.currentSkillItem {
            activeSkillItem.buttonDelete.alpha = 0
            activeSkillItem.buttonDelete.isUserInteractionEnabled = false
            activeSkillItem.backgroundColor = UIColor.clear
        }
        
        self.currentExperienceItem = item
        
        if let activeItem = self.currentExperienceItem {
            activeItem.buttonDelete.alpha = 1
            activeItem.buttonDelete.isUserInteractionEnabled = true
            activeItem.backgroundColor = UIColor.darkGray
        }
    }
}

// View Function
extension ProfileViewController {
    func setupView() {
        self.imageProfile.layer.cornerRadius = self.imageProfile.frame.width / 2
        self.logoutView.layer.cornerRadius = 6
        self.buttonLogout.layer.cornerRadius = 6
        
        self.buttonAddEducation.imageView?.contentMode = .scaleAspectFill
        
        self.setupStackView(stackView: self.educationStackView)
        self.setupStackView(stackView: self.workingExperienceStackView)
        self.setupStackView(stackView: self.skillStackView)
        
        self.setActivityIndicator(loading: true)
    }
    
   func setupStackView(stackView: UIStackView) {
        stackView.safelyRemoveAllArrangedSubviews()
        stackView.layer.cornerRadius = 6
        stackView.layer.borderColor = UIColor.white.cgColor
        stackView.layer.borderWidth = 0.7
        
        stackView.alpha = 0
        stackView.animateFadeIn()
    }
    
    func setupNoDataItem(_ stackView: UIStackView) {
        let view = UIView()
        view.layer.backgroundColor = UIColor.clear.cgColor
        
        let label = UILabel()
        label.textColor = UIColor.white
        label.text = "No Data."
        
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        stackView.addArrangedSubview(view)
        view.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(50)
        }
    }
    
    func setActivityIndicator(loading: Bool) {
        if loading {
            self.activityIndicator.animateFadeIn()
            self.activityIndicator.startAnimating()
        } else {
            self.activityIndicator.animateFadeOut()
            self.activityIndicator.stopAnimating()
        }
    }
    
    func addSeparatorView(_ stackView: UIStackView) {
        let view = UIView()
        view.backgroundColor = UIColor.white
        
        stackView.addArrangedSubview(view)
        view.snp.makeConstraints { make in
            make.height.equalTo(0.75)
            make.leading.equalToSuperview().offset(8)
            make.trailing.equalToSuperview().offset(-8)
        }
    }
    
    func setupRightBarItem() {
        let buttonProfile = UIBarButtonItem(image: UIImage(systemName: "pencil"), style: .plain, target: self, action: #selector(navigateToChangeProfile))
        self.navigationItem.rightBarButtonItem = buttonProfile
    }
    
    @objc func navigateToChangeProfile() {
        let viewModel = ProfileChangeViewModel()
        let viewController = ProfileChangeViewController(viewModel: viewModel)
        
        UIApplication.topViewController()?.navigationController?.pushViewController(viewController, animated: true)
    }
}
