//
//  HomeViewController.swift
//  GGGaming
//
//  Created by IT Division on 11/03/21.
//

import UIKit

class HomeViewController: UIViewController {
    
    let changeTitle: (_ title: String) -> Void
    let viewModel: HomeViewModel
    
    init(
        callBack: @escaping (_ title: String) -> Void,
        viewModel: HomeViewModel
    ) {
        self.changeTitle = callBack
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.changeTitle("Home")
    }
    
}
