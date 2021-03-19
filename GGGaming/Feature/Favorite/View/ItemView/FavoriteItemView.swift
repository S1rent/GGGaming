//
//  FavoriteItemView.swift
//  GGGaming
//
//  Created by IT Division on 15/03/21.
//

import UIKit

class FavoriteItemView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var imageGame: UIImageView!
    @IBOutlet weak var labelGameName: UILabel!
    @IBOutlet weak var roundedView: UIView!
    @IBOutlet weak var labelRating: UILabel!
    @IBOutlet weak var detailView: UIView!
    @IBOutlet weak var buttonDetail: UIButton!
    @IBOutlet weak var buttonRemove: UIButton!
    @IBOutlet weak var removeView: UIView!
    @IBOutlet weak var labelReleaseDate: UILabel!
    
    let gameData: FavoriteModel
    let callBack: (() -> Void)
    
    init(
        gameData: FavoriteModel,
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
        Bundle.main.loadNibNamed(FavoriteItemView.identifier, owner: self, options: nil)
        self.addSubview(self.contentView)
        self.contentView.frame = self.bounds
        self.contentView.layer.masksToBounds = true
        
        self.setupView()
    }
    
    public func setData(gameData: FavoriteModel) {
        self.labelRating.text = "\(gameData.gameRating )"
        self.labelGameName.text = gameData.gameName 
        self.imageGame.sd_setImage(with: URL(string: gameData.gamePictureURL), placeholderImage: #imageLiteral(resourceName: "icn-broken-photo"))
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: gameData.gameReleaseDate ) else { return }
        dateFormatter.dateFormat = "dd MMMM yyyy"
        self.labelReleaseDate.text = "Released: \(dateFormatter.string(from: date))"
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
        _ = FavoriteCoreDataFunctionality.shared.removeFavorite(self.gameData.gameID )
        let alertController = UIAlertController(title: "Information", message: "Successfully remove game from favorite.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(okAction)
        
        UIApplication.topViewController()?.navigationController?.present(alertController, animated: true, completion: {
            self.callBack()
        })
    }
    
    @IBAction func removeGameTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Warning", message: "Are you sure you want to remove this game from your favorite ?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
            self.presentInformation()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        UIApplication.topViewController()?.navigationController?.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func detailTapped(_ sender: Any) {
        GameNavigator.shared.navigateToGameDetail(gameID: self.gameData.gameID)
    }
}
