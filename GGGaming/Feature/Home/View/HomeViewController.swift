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
    
    // Tableview Outlet
    @IBOutlet weak var tableView: UITableView!
    
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
    let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, Any>>(configureCell: { (_, tableView, _, data) in
        if let gameData = data as? Game {
            let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.identifier) as? HomeTableViewCell ?? HomeTableViewCell()
            cell.selectionStyle = .none
            cell.setData(gameData)
            return cell
        } else {
            return UITableViewCell()
        }
    }, titleForHeaderInSection: { dataSource, sectionIndex in
        return dataSource[sectionIndex].model
    })
    
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
        self.setupTableView()
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
            output.gameData.drive(self.tableView.rx.items(dataSource: dataSource)),
            output.loading.drive(onNext: { [weak self] loading in
                guard let self = self else { return }
                
                if loading {
                    self.activityIndicator.animateFadeIn()
                    self.developerView.animateFadeOut()
                } else {
                    self.activityIndicator.animateFadeOut()
                    self.developerView.animateFadeIn()
                }
            })
        )
    }
    
    private func setupCollectionView() {
        self.collectionView.register(HomeCollectionViewCell.uiNib, forCellWithReuseIdentifier: HomeCollectionViewCell.identifier)
        
        let layout: UICollectionViewFlowLayout = self.collectionView?.collectionViewLayout as? UICollectionViewFlowLayout ?? UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 250, height: 160)
        self.collectionView.setCollectionViewLayout(layout, animated: true)
    }
    
    private func setupTableView() {
        self.tableView.register(HomeTableViewCell.uiNib, forCellReuseIdentifier: HomeTableViewCell.identifier)
        self.tableView.rx.setDelegate(self).disposed(by: self.rx.disposeBag)
        self.tableView.rowHeight = UITableView.automaticDimension
    }
    
    private func setupView() {
        self.buttonViewAllDeveloper.layer.cornerRadius = 6
        self.buttonViewAllDeveloper.layer.backgroundColor = UIColor.white.cgColor
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
           let containerView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 70))
           
           let label = UILabel()
           label.text = dataSource[section].model
           label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            label.font = .boldSystemFont(ofSize: 24)
           label.sizeToFit()
           containerView.addSubview(label)
           label.snp.makeConstraints { make in
               make.left.equalToSuperview().offset(16)
               make.right.equalToSuperview().offset(16)
               make.centerY.equalToSuperview()
           }
        containerView.backgroundColor = UIColor.black
           return containerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
}
