//
//  HomeViewController.swift
//  GGGaming
//
//  Created by IT Division on 11/03/21.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
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
        
        self.setupCollectionView()
    }
    
    private func setupCollectionView() {
        self.collectionView.register(HomeCollectionViewCell.uiNib, forCellWithReuseIdentifier: "CampusDirectoryCollectionViewCell")
        
        let layout: UICollectionViewFlowLayout = self.collectionView?.collectionViewLayout as? UICollectionViewFlowLayout ?? UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: self.collectionView.frame.width - 100, height: self.collectionView.frame.height - 5)
        self.collectionView.setCollectionViewLayout(layout, animated: true)
    }
    
}
