//
//  GameDetailViewController.swift
//  GGGaming
//
//  Created by IT Division on 12/03/21.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

class GameDetailViewController: UIViewController {
    
    @IBOutlet weak var imageGamePhotoMain: UIImageView!
    @IBOutlet weak var imageGamePhotoAdditional: UIImageView!
    @IBOutlet weak var labelRating: UILabel!
    @IBOutlet weak var labelGameName: UILabel!
    @IBOutlet weak var labelGameReleaseDate: UILabel!
    @IBOutlet weak var labelGameDescription: UILabel!
    @IBOutlet weak var labelGameDeveloper: UILabel!
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var noResultView: UIView!
    @IBOutlet weak var labelNoData: UILabel!
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
    
    let viewModel: GameDetailViewModel
    let loadTrigger: BehaviorRelay<Void>
    
    var hasData = false
    
    init(viewModel: GameDetailViewModel) {
        self.viewModel = viewModel
        self.loadTrigger = BehaviorRelay<Void>(value: ())
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Game Detail"

        self.setupView()
        self.bindUI()
    }
    
    private func bindUI() {
        let output = self.viewModel.transform(input: GameDetailViewModel.Input(
            loadTrigger: self.loadTrigger.asDriver()
        ))
        
        self.rx.disposeBag.insert(
            output.data.drive(onNext: { [weak self] data in
                guard let self = self else { return }
                
                self.hasData = true
                self.setData(data)
            }),
            output.loading.drive(onNext: { [weak self] loading in
                guard let self = self else { return }
                
                if loading {
                    self.activityIndicator.animateFadeIn()
                    self.activityIndicator.startAnimating()
                } else {
                    self.activityIndicator.animateFadeOut()
                    self.activityIndicator.stopAnimating()
                    
                    if self.hasData {
                        self.noResultView.animateFadeOut()
                    } else {
                        self.labelNoData.alpha = 1
                    }
                }
            })
        )
    }
    
    private func setData(_ data: GameDetailResponseWrapper) {
        self.labelRating.text = "\(data.gameRating ?? 0)"
        self.labelGameName.text = data.gameName ?? ""
        self.labelGameDescription.attributedText = data.gameDescription?.html2AttributedString?.trimmedAttributedString()
        self.labelGameDescription.textColor = UIColor.white
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: data.gameReleaseDate ?? "") else { return }
        dateFormatter.dateFormat = "dd MMMM yyyy"
        self.labelGameReleaseDate.text = dateFormatter.string(from: date)
        
        self.imageGamePhotoMain.sd_setImage(with: URL(string: data.gameImagePreview ?? ""), placeholderImage: #imageLiteral(resourceName: "icn-broken-photo"))
        self.imageGamePhotoAdditional.sd_setImage(with: URL(string: data.gameAdditionalImagePreview ?? ""), placeholderImage: #imageLiteral(resourceName: "icn-broken-photo"))
        
        var developerString: String = ""
        let developers = data.developers ?? []
        for (index, developer) in developers.enumerated() {
            developerString += developer.developerName ?? ""
            if index != developers.count - 1 {
                developerString += ", "
            }
        }
        
        self.labelGameDeveloper.text = developerString
    }
    
    private func setupView() {
        self.ratingView.layer.cornerRadius = 6
        self.imageGamePhotoMain.layer.cornerRadius = 6
        self.imageGamePhotoAdditional.layer.cornerRadius = 6
    }
}
