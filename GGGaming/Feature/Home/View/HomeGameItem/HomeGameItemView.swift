//
//  HomeGameItem.swift
//  GGGaming
//
//  Created by IT Division on 12/03/21.
//

import UIKit

class HomeGameItemView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var labelGameName: UILabel!
    @IBOutlet weak var labelGameRating: UILabel!
    @IBOutlet weak var labelGameReleaseDate: UILabel!
    @IBOutlet weak var imageGame: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var middleView: UIView!
    
    let data: Game
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.headerView.roundCorners(corners: [.topLeft, .topRight], radius: 6)
    }
    
    init(_ data: Game) {
        self.data = data
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        
        self.bindNib()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func bindNib() {
        Bundle.main.loadNibNamed(HomeGameItemView.identifier, owner: self, options: nil)
        self.addSubview(self.contentView)
        self.contentView.frame = self.bounds
        self.contentView.layer.masksToBounds = true
        
        self.setupView()
    }
    
    public func setData(_ data: Game) {
        self.labelGameName.text = data.gameName ?? ""
        self.labelGameRating.text = "\(data.gameRating ?? 0.0)"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: data.gameReleaseDate ?? "") else { return }
        dateFormatter.dateFormat = "dd MMMM yyyy"
        self.labelGameReleaseDate.text = dateFormatter.string(from: date)
        
        self.imageGame.sd_setImage(with: URL(string: data.gameImagePreview ?? ""), placeholderImage: #imageLiteral(resourceName: "icn-broken-photo"))
    }
    
    private func setupView() {
        self.containerView.layer.borderWidth = 1
        self.containerView.layer.borderColor = UIColor.white.cgColor
        self.containerView.layer.cornerRadius = 6
    }
    
    @IBAction func navigateToGameDetail(_ sender: Any) {
        GameNavigator.shared.navigateToGameDetail(gameData: self.data)
    }
}
