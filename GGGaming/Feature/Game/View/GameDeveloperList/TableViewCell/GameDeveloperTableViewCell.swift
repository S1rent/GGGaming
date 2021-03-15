//
//  GameDeveloperTableViewCell.swift
//  GGGaming
//
//  Created by IT Division on 15/03/21.
//

import UIKit

class GameDeveloperTableViewCell: UITableViewCell {

    @IBOutlet weak var imageDeveloper: UIImageView!
    @IBOutlet weak var labelDeveloperName: UILabel!
    @IBOutlet weak var labelDeveloperGameCount: UILabel!
    @IBOutlet weak var roundView: UIView!
    @IBOutlet weak var borderView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func setData(_ data: Developer) {
        self.labelDeveloperName.text = data.developerName ?? ""
        self.labelDeveloperGameCount.text = "\(data.developerGamesCount ?? 0) games"
        self.imageDeveloper.sd_setImage(with: URL(string: data.developerImagePreview ?? ""), placeholderImage: #imageLiteral(resourceName: "icn-broken-photo"))
    }
    
    private func setupView() {
        self.roundView.layer.cornerRadius = 6.1
        self.imageDeveloper.layer.cornerRadius = 6.1
        self.borderView.layer.cornerRadius = 6.1
        self.borderView.layer.borderWidth = 1.5
        self.borderView.layer.borderColor = UIColor.white.cgColor
    }
}
