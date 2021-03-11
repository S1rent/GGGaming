//
//  HomeTabBarViewController.swift
//  GGGaming
//
//  Created by IT Division on 11/03/21.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

class HomeTabBarViewController: UITabBarController {

    let viewModel: HomeTabBarViewModel
    let loadTrigger = BehaviorRelay<Void>(value: ())
    
    init() {
        self.viewModel = HomeTabBarViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavigationBar()
        self.setupTabBarView()
        
        self.bindUI()
    }
    
    private func bindUI() {
        let output = self.viewModel.transform(input: HomeTabBarViewModel.Input(
            loadTrigger: loadTrigger.asDriver(),
            callBack: self.changeNavigationBarTitle
        ))
        
        self.rx.disposeBag.insert(
            output.data.drive(onNext: { [weak self] viewControllers in
                self?.viewControllers = viewControllers
            })
        )
    }
    
    private func setupNavigationBar() {
        UINavigationBar.appearance().barTintColor = UIColor.black
        UINavigationBar.appearance().tintColor = UIColor.white
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    private func setupTabBarView() {
        self.tabBar.tintColor = UIColor.white
        self.tabBar.barTintColor = UIColor.black
        self.tabBar.isTranslucent = false
    }
    
    func changeNavigationBarTitle(title: String) {
        self.title = title
    }
}
