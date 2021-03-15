//
//  HomeCollectionViewCell.swift
//  GGGaming
//
//  Created by IT Division on 12/03/21.
//

import UIKit
import SDWebImage

class HomeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageDeveloper: UIImageView!
    @IBOutlet weak var labelDeveloperName: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.imageDeveloper.roundCorners(corners: [.topLeft, .topRight], radius: 6)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        self.setupView()
    }
    
    public func setData(_ data: Developer) {
        self.imageDeveloper.sd_setImage(with: URL(string: data.developerImagePreview ?? ""), placeholderImage: #imageLiteral(resourceName: "icn-broken-photo"))
        self.labelDeveloperName.text = data.developerName ?? ""
    }
    
    private func setupView() {
        self.containerView.layer.cornerRadius = 6
        self.containerView.layer.borderColor = UIColor.white.cgColor
        self.containerView.layer.borderWidth = 2
    }
}
