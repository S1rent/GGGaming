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
        self.stackView.safelyRemoveAllArrangedSubviews()
        self.labelSearchResult.text = "Search result for \"\(self.searchKey)\""
    }
}
