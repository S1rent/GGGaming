//
//  WishlistItemView.swift
//  GGGaming
//
//  Created by IT Division on 15/03/21.
//

import UIKit

class WishlistItemView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var imageGame: UIImageView!
    @IBOutlet weak var labelGameName: UILabel!
    @IBOutlet weak var roundedView: UIView!
    @IBOutlet weak var labelRating: UILabel!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var buttonDetail: UIButton!
    @IBOutlet weak var buttonRemove: UIButton!
    @IBOutlet weak var removeView: UIView!
    
    let gameData: Game
    let callBack: (() -> Void)
    
    init(
        gameData: Game,
        callBack: @escaping () -> Void
    ) {
        self.gameData = gameData
        self.callBack = callBack
        
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        bindNib()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bindNib() {
        Bundle.main.loadNibNamed(WishlistItemView.identifier, owner: self, options: nil)
        self.addSubview(self.contentView)
        self.contentView.frame = self.bounds
        self.contentView.layer.masksToBounds = true
        
        self.setupView()
    }
    
    public func setData(gameData: Game) {
        self.labelRating.text = "\(gameData.gameRating ?? 0.0)"
        self.labelGameName.text = gameData.gameName ?? ""
        self.imageGame.sd_setImage(with: URL(string: gameData.gameImagePreview ?? ""), placeholderImage: #imageLiteral(resourceName: "icn-broken-photo"))
    }
    
    private func setupView() {
        self.contentView.layer.borderWidth = 1.5
        self.contentView.layer.borderColor = UIColor.white.cgColor
        self.contentView.layer.cornerRadius = 6
        
        self.imageGame.layer.cornerRadius = 6
        self.roundedView.layer.cornerRadius = 6
        self.detailView.layer.cornerRadius = 6
        self.removeView.layer.cornerRadius = 6
        self.buttonDetail.layer.cornerRadius = 6
    }
    
    private func presentInformation() {
        Wishlist.shared.removeGameFromWishList(game: self.gameData)
        let alertController = UIAlertController(title: "Information", message: "Successfully remove game from wishlist.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        UIApplication.topViewController()?.navigationController?.present(alertController, animated: true, completion: {
            self.callBack()
        })
    }
    
    @IBAction func removeGameTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Warning", message: "Are you sure you want to remove this game from your wishlist ?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.presentInformation()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        UIApplication.topViewController()?.navigationController?.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func detailTapped(_ sender: Any) {
        GameNavigator.shared.navigateToGameDetail(gameData: self.gameData)
    }
}
