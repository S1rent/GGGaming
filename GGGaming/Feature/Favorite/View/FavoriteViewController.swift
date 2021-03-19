//
//  FavoriteViewController.swift
//  GGGaming
//
//  Created by IT Division on 11/03/21.
//

import UIKit
import RxCocoa
import RxSwift

class FavoriteViewController: UIViewController {
    
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
    
    let changeTitle: (_ title: String) -> Void
    let viewModel: FavoriteViewModel
    let loadRelay: BehaviorRelay<Void>
    
    init(
        callBack: @escaping (_ title: String) -> Void,
        viewModel: FavoriteViewModel
    ) {
        self.changeTitle = callBack
        self.viewModel = viewModel
        self.loadRelay = BehaviorRelay<Void>(value: ())
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.changeTitle("Favorite")
        
        self.setActivityIndicator(loading: true)
        self.noResultView.alpha = 1
        self.noResultView.isHidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
        self.setActivityIndicator(loading: true)
        self.bindUI()
    }

    private func bindUI() {
        let willAppear = self.rx.sentMessage(#selector(UIViewController.viewWillAppear(_:))).mapToVoid().asDriverOnErrorJustComplete()
        let output = self.viewModel.transform(input: FavoriteViewModel.Input(
            loadTrigger: Driver.merge(self.loadRelay.asDriver(), willAppear)
        ))
        
        self.rx.disposeBag.insert(
            output.data.drive(onNext: { [weak self] data in
                guard let self = self else { return }
                
                self.setupStackViewData(data)
            }),
            output.hasData.drive(onNext: { [weak self] hasData in
                guard let self = self else { return }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
                    guard let self = self else { return }
                    
                    self.setActivityIndicator(loading: false)
                    
                    if hasData {
                        self.noResultView.animateFadeOut()
                    } else {
                        self.labelNoData.alpha = 1
                    }
                }
            })
        )
    }
    
    private func setupStackViewData(_ gameList: [Game]) {
        self.stackView.safelyRemoveAllArrangedSubviews()
        for game in gameList {
            let item = FavoriteItemView(gameData: game, callBack: self.refreshCallback)
            item.setData(gameData: game)
            
            self.stackView.addArrangedSubview(item)
        }
    }
    
    public func refreshCallback() {
        self.viewWillAppear(true)
        self.loadRelay.accept(())
    }
    
    private func setupView() {
        self.stackView.safelyRemoveAllArrangedSubviews()
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
