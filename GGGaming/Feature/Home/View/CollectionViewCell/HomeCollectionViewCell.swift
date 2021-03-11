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
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        self.setupView()
    }
    
    private func setupView() {
        self.containerView.layer.cornerRadius = 6
        self.containerView.layer.borderColor = UIColor.white.cgColor
        self.containerView.layer.borderWidth = 0.6
    }

}
