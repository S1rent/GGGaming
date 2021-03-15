//
//  GameDeveloperListViewController.swift
//  GGGaming
//
//  Created by IT Division on 15/03/21.
//

import UIKit
import RxSwift
import RxCocoa

class GameDeveloperListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
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
    
    let viewModel: GameDeveloperListViewModel
    let loadRelay: BehaviorRelay<Void>
    
    var hasData = false
    
    init(viewModel: GameDeveloperListViewModel) {
        self.viewModel = viewModel
        self.loadRelay = BehaviorRelay<Void>(value: ())
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Developers"
        
        self.setupTableView()
        self.bindUI()
    }
    
    private func bindUI() {
        let output = self.viewModel.transform(input: GameDeveloperListViewModel.Input(
            loadTrigger: self.loadRelay.asDriver()
        ))
        
        self.rx.disposeBag.insert(
            output.data.drive(self.tableView.rx.items(cellIdentifier: GameDeveloperTableViewCell.identifier, cellType: GameDeveloperTableViewCell.self)) { (_, data, cell) in
                
                cell.setData(data)
            },
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
            }),
            output.noData.drive(onNext: { [weak self] noData in
                guard let self = self else { return }
                
                self.hasData = noData
            })
        )
    }
    
    private func setupTableView() {
        self.tableView.register(GameDeveloperTableViewCell.uiNib, forCellReuseIdentifier: GameDeveloperTableViewCell.identifier)
        self.tableView.estimatedRowHeight = UITableView.automaticDimension
        self.tableView.rx.modelSelected(Any.self)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { data in
                if let developerData = data as? Developer {
                    GameNavigator.shared.navigateToSearchedGameResultByDeveloperPage(developerData: developerData)
                }
                
                self.deselectTableView()
            }, onError: nil, onCompleted: nil, onDisposed: nil)
            .disposed(by: self.rx.disposeBag)
    }

    private func deselectTableView() {
        if let index = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: index, animated: true)
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
}
