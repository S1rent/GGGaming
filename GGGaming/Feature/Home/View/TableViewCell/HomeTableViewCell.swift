//
//  HomeTableViewCell.swift
//  GGGaming
//
//  Created by IT Division on 12/03/21.
//

import UIKit

class HomeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelGameName: UILabel!
    @IBOutlet weak var labelGameRating: UILabel!
    @IBOutlet weak var labelGameReleaseDate: UILabel!
    @IBOutlet weak var imageGame: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    public func setData(_ data: Game) {
        self.labelGameName.text = data.gameName ?? ""
        self.labelGameRating.text = "\(data.gameRating ?? 0.0)"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: data.gameReleaseDate ?? "") else { return }
        dateFormatter.dateFormat = "dd MM yyyy"
        self.labelGameReleaseDate.text = dateFormatter.string(from: date)
        
        self.imageGame.sd_setImage(with: URL(string: data.gameImagePreview ?? ""), placeholderImage: #imageLiteral(resourceName: "icn-broken-photo"))
    }
}
