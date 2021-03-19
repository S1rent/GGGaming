//
//  ExperienceItemView.swift
//  GGGaming
//
//  Created by IT Division on 11/03/21.
//

import UIKit

class ExperienceItemView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var labelDuration: UILabel!
    @IBOutlet weak var roundedView: UIView!
    @IBOutlet weak var labelDescription: UILabel!
    @IBOutlet weak var buttonDelete: UIButton!
    
    let callBack: ((_ stackView: ExperienceItemView) -> Void)
    let refreshCallback: (() -> Void)
    let data: Experience
    let type: ProfileAddItemEnum
    
    init(
        callBack: @escaping ((_ stackView: ExperienceItemView) -> Void),
        data: Experience,
        refreshCallback: @escaping (() -> Void),
        type: ProfileAddItemEnum
    ) {
        self.callBack = callBack
        self.data = data
        self.refreshCallback = refreshCallback
        self.type = type
        
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 100))
        
        self.bindNib()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bindNib() {
        Bundle.main.loadNibNamed(ExperienceItemView.identifier, owner: self, options: nil)
        self.addSubview(self.contentView)
        self.contentView.frame = self.bounds
        self.contentView.layer.masksToBounds = true
        
        self.setupView()
    }
    
    private func setupView() {
        self.roundedView.layer.cornerRadius = self.roundedView.frame.width/2
    }
    
    @IBAction func deleteTapped(_ sender: Any) {
        if self.type == ProfileAddItemEnum.education {
            UserService.shared.removeEducationFromEducationList(self.data)
        } else {
            UserService.shared.removeExperienceFromExperienceList(self.data)
        }
        self.refreshCallback()
    }
    
    @IBAction func viewTapped(_ sender: Any) {
        self.callBack(self)
    }
}
