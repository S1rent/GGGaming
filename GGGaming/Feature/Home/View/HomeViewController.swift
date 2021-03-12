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
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var initView: UIView!
    
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
        let output = viewModel.transform(input: HomeViewModel.Input(
            loadTrigger: self.loadRelay.asDriver()
        ))
        
        self.rx.disposeBag.insert(
            output.developerData.drive(self.collectionView.rx.items(cellIdentifier: HomeCollectionViewCell.identifier, cellType: HomeCollectionViewCell.self)) { (_, data, cell) in
                cell.setData(data)
            },
            output.gameData.drive(onNext: { [weak self] data in
                guard let self = self else { return }
                self.setupStackViewData(data)
            }),
            output.loading.drive(onNext: { [weak self] loading in
                guard let self = self else { return }
                
                if loading {
                    self.activityIndicator.animateFadeIn()
                    self.activityIndicator.startAnimating()
                    self.developerView.animateFadeOut()
                } else {
                    self.activityIndicator.animateFadeOut()
                    self.activityIndicator.stopAnimating()
                    self.developerView.animateFadeIn()
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
    }
    
    private func setupView() {
        self.buttonViewAllDeveloper.layer.cornerRadius = 6
        self.buttonViewAllDeveloper.layer.backgroundColor = UIColor.white.cgColor
        self.stackView.safelyRemoveAllArrangedSubviews()
        self.stackView.isUserInteractionEnabled = true
    }
}
