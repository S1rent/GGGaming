//
//  HomeViewController.swift
//  GGGaming
//
//  Created by IT Division on 11/03/21.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class HomeViewController: UIViewController {
    
    // Developer Outlet
    @IBOutlet weak var developerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var buttonViewAllDeveloper: UIButton!
    
    // Search Bar Outlet
    @IBOutlet weak var searchBar: UISearchBar!
    
    // Top Rated View Outlet
    @IBOutlet weak var topGameView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var initView: UIView!
    @IBOutlet weak var labelTopRatedGames: UILabel!
    
    // Other Outlet
    @IBOutlet weak var labelNoData: UILabel!
    @IBOutlet weak var noResultView: UIView!
    
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
    let viewModel: HomeViewModel
    let loadRelay: BehaviorRelay<Void>
    
    var hasCollectionData = false
    var hasGameData = false
    
    init(
        callBack: @escaping (_ title: String) -> Void,
        viewModel: HomeViewModel
    ) {
        self.changeTitle = callBack
        self.viewModel = viewModel
        self.loadRelay = BehaviorRelay<Void>(value: ())
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.changeTitle("Home")
        
        self.setupView()
        self.setupCollectionView()
        self.bindUI()
    }
    
    private func bindUI() {
        let willAppear = self.rx.sentMessage(#selector(UIViewController.viewWillAppear(_:)))
            .mapToVoid()
            .asDriverOnErrorJustComplete()
        
        let output = viewModel.transform(input: HomeViewModel.Input(
            loadTrigger: self.loadRelay.asDriver(),
            searchedText: self.searchBar.rx.text.orEmpty.asDriverOnErrorJustComplete().skip(1).debounce(RxTimeInterval.milliseconds(500)),
            willAppearTrigger: willAppear
        ))
        
        self.rx.disposeBag.insert(
            output.developerData.drive(self.collectionView.rx.items(cellIdentifier: HomeCollectionViewCell.identifier, cellType: HomeCollectionViewCell.self)) { (_, data, cell) in
                cell.setData(data)
            },
            output.developerData.drive(onNext: { [weak self] _ in
                guard let self = self else { return }
                
                self.hasCollectionData = true
            }),
            output.gameData.drive(onNext: { [weak self] data in
                guard let self = self else { return }
                
                self.hasGameData = true
                self.setupStackViewData(data)
            }),
            output.searchedGameData.drive(onNext: { [weak self] data in
                guard let self = self else { return }
                
                GameNavigator.shared.navigateToSearchedGameResultPage(gameData: data, searchedKey: self.searchBar.text ?? "")
            }),
            output.loading.drive(onNext: { [weak self] loading in
                guard let self = self else { return }
                
                if loading {
                    self.activityIndicator.animateFadeIn()
                    self.activityIndicator.startAnimating()
                } else {
                    self.activityIndicator.animateFadeOut()
                    self.activityIndicator.stopAnimating()
                    
                    self.setupNoResultView()
                }
            })
        )
    }
    
    private func setupStackViewData(_ data: [Game]) {
        for game in data {
            let gameItemRow = HomeGameItemView(game)
            
            gameItemRow.setData(game)
            self.stackView.addArrangedSubview(gameItemRow)
        }
    }
    
    private func setupCollectionView() {
        self.collectionView.register(HomeCollectionViewCell.uiNib, forCellWithReuseIdentifier: HomeCollectionViewCell.identifier)
        
        let layout: UICollectionViewFlowLayout = self.collectionView?.collectionViewLayout as? UICollectionViewFlowLayout ?? UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 250, height: 160)
        self.collectionView.setCollectionViewLayout(layout, animated: true)
        
        self.collectionView.rx.modelSelected(Any.self)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { data in
                if let developerData = data as? Developer {
                    GameNavigator.shared.navigateToSearchedGameResultByDeveloperPage(developerData: developerData)
                }
                self.deselectCollectionItem()
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: self.rx.disposeBag)
    }
    
    private func setupNoResultView() {
        if self.hasCollectionData && self.hasGameData {
            self.noResultView.animateFadeOut()
            self.labelTopRatedGames.isHidden = false
            self.stackView.isHidden = false
        } else if self.hasCollectionData && !self.hasGameData {
            self.noResultView.animateFadeOut()
            self.topGameView.snp.remakeConstraints { (remake) in
                remake.height.equalTo(0)
            }
        } else if !self.hasCollectionData && self.hasGameData {
            self.noResultView.animateFadeOut()
            self.developerView.snp.remakeConstraints { (remake) in
                remake.height.equalTo(0)
            }
        } else {
            self.labelNoData.alpha = 1
        }
    }
    
    private func setupView() {
        self.buttonViewAllDeveloper.layer.cornerRadius = 6
        self.buttonViewAllDeveloper.layer.backgroundColor = UIColor.white.cgColor
        self.stackView.safelyRemoveAllArrangedSubviews()
        self.stackView.isUserInteractionEnabled = true
        self.searchBar.searchTextField.delegate = self
    }
    
    private func deselectCollectionItem() {
        if let index = self.collectionView.indexPathsForSelectedItems {
            self.collectionView.deselectItem(at: index[0], animated: true)
        }
    }
}

extension HomeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
