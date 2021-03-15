//
//  GameSearchResultByDeveloperViewController.swift
//  GGGaming
//
//  Created by IT Division on 15/03/21.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

class GameListByDeveloperViewController: UIViewController {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var initView: UIView!
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
    
    let data: Developer
    let viewModel: GameListByDeveloperViewModel
    let loadRelay: BehaviorRelay<Void>
    
    var hasData = false
    
    init(developerData: Developer, viewModel: GameListByDeveloperViewModel) {
        self.data = developerData
        self.viewModel = viewModel
        self.loadRelay = BehaviorRelay<Void>(value: ())
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "\(self.data.developerName ?? "") Games"
        
        self.setupView()
        self.bindUI()
    }
    
    private func bindUI() {
        let output = self.viewModel.transform(input: GameListByDeveloperViewModel.Input(
            loadTrigger: self.loadRelay.asDriver()
        ))
        
        self.rx.disposeBag.insert(
            output.data.drive(onNext: { [weak self] data in
                guard let self = self else { return }
                
                self.setupStackViewData(data)
            }),
            output.noData.drive(onNext: { [weak self] noData in
                guard let self = self else { return }
                
                self.hasData = noData
            }),
            output.loading.drive(onNext: { [weak self] loading in
                guard let self = self else { return }
                
                if loading {
                    self.setActivityIndicator(loading: true)
                    self.noResultView.animateFadeIn()
                } else {
                    self.setActivityIndicator(loading: false)
                    
                    if self.hasData {
                        self.noResultView.animateFadeOut()
                    } else {
                        self.labelNoData.alpha = 1
                    }
                }
            })
        )
    }
    
    private func setupStackViewData(_ data: [Game]) {
        for game in data {
            let gameItem = HomeGameItemView(game)
            gameItem.setData(game)
            
            self.stackView.addArrangedSubview(gameItem)
        }
    }
    
    private func setActivityIndicator(loading: Bool) {
        if loading {
            self.activityIndicator.animateFadeIn()
            self.activityIndicator.startAnimating()
        } else {
            self.activityIndicator.animateFadeOut()
            self.activityIndicator.stopAnimating()
        }
    }

    private func setupView() {
        self.stackView.safelyRemoveAllArrangedSubviews()
    }
}
