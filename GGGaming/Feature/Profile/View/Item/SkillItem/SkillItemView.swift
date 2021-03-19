//
//  SkillItemView.swift
//  GGGaming
//
//  Created by IT Division on 11/03/21.
//

import UIKit

class SkillItemView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var labelSkillName: UILabel!
    @IBOutlet weak var roundedView: UIView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var buttonDelete: UIButton!
    
    let callBack: ((_ stackView: SkillItemView) -> Void)
    let refreshCallback: (() -> Void)
    let data: Skill
    
    init(
        callBack: @escaping ((_ stackView: SkillItemView) -> Void),
        data: Skill,
        refreshCallback: @escaping (() -> Void)
    ) {
        self.callBack = callBack
        self.data = data
        self.refreshCallback = refreshCallback
        
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        self.bindNib()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bindNib() {
        Bundle.main.loadNibNamed(SkillItemView.identifier, owner: self, options: nil)
        self.addSubview(self.contentView)
        self.contentView.frame = self.bounds
        self.contentView.layer.masksToBounds = true
        
        self.setupView()
    }
    
    private func setupView() {
        self.buttonDelete.isUserInteractionEnabled = false
        self.roundedView.layer.cornerRadius = self.roundedView.frame.width / 2
        self.progressView.layer.cornerRadius = 6
    }
    
    @IBAction func deleteTapped(_ sender: Any) {
        UserService.shared.removeSkillFromSkillList(self.data)
        self.refreshCallback()
    }
    
    @IBAction func viewTapped(_ sender: Any) {
        self.callBack(self)
    }
}
