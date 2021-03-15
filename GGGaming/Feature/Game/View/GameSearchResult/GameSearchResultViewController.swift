//
//  GameSearchResultViewController.swift
//  GGGaming
//
//  Created by IT Division on 14/03/21.
//

import UIKit
import RxSwift
import RxCocoa

class GameSearchResultViewController: UIViewController {
    
    @IBOutlet weak var initView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var labelSearchResult: UILabel!
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
    
    let searchKey: String
    let viewModel: GameSearchResultViewModel
    let loadRelay: BehaviorRelay<Void>
    
    init(searchKey: String, viewModel: GameSearchResultViewModel) {
        self.searchKey = searchKey
        self.viewModel = viewModel
        self.loadRelay = BehaviorRelay<Void>(value: ())
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Search Game"
        
        self.setupView()
        self.bindUI()
    }
    
    private func bindUI() {
        let output = self.viewModel.transform(input: GameSearchResultViewModel.Input(
            loadTrigger: self.loadRelay.asDriver()
        ))
        
        self.rx.disposeBag.insert(
            output.data.drive(onNext: { [weak self] data in
                guard let self = self else { return }
                
                self.setupStackViewData(data)
            }),
            output.noData.drive(onNext: { [weak self] noData in
                guard let self = self else { return }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
                    guard let self = self else { return }
                    self.setActivityIndicator(loading: false)
                    
                    if !noData {
                        self.labelNoData.alpha = 1
                    } else {
                        self.noResultView.animateFadeOut()
                    }
                }
            })
        )
    }
    
    private func setupStackViewData(_ gameList: [Game]) {
        for game in gameList {
            let gameItem = HomeGameItemView(game)
            gameItem.setData(game)
            
            self.stackView.addArrangedSubview(gameItem)
        }
    }
    
    private func setupView() {
        self.setActivityIndicator(loading: true)
        self.stackView.safelyRemoveAllArrangedSubviews()
        self.labelSearchResult.text = "Search result for \"\(self.searchKey)\""
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
}
