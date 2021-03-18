//
//  HomeTabBarViewControllerList.swift
//  GGGaming
//
//  Created by IT Division on 11/03/21.
//

import Foundation
import UIKit

final class HomeTabBarViewControllerList {
    static let shared = HomeTabBarViewControllerList()
    var callBack: ((_ title: String) -> Void) = { _ in }
    
    public init() { }
    
    func getHomeViewController() -> UIViewController {
        let viewModel = HomeViewModel()
        let viewController = HomeViewController(callBack: callBack, viewModel: viewModel)
        
        viewController.tabBarItem = UITabBarItem(title: "Home", image: #imageLiteral(resourceName: "icn-home"), tag: 0)
        viewController.tabBarItem.imageInsets = UIEdgeInsets.init(top: -5, left: -5, bottom: -5, right: -5)
        
        return viewController
    }
    
    func getWishlistViewController() -> UIViewController {
        let viewModel = FavoriteViewModel()
        let viewController = FavoriteViewController(callBack: callBack, viewModel: viewModel)
        
        viewController.tabBarItem = UITabBarItem(title: "Favorite", image: #imageLiteral(resourceName: "icn-wishlist"), tag: 0)
        viewController.tabBarItem.imageInsets = UIEdgeInsets.init(top: -5, left: -5, bottom: -5, right: -5)
        
        return viewController
    }
    
    func setTitleChangeCallback(callBack: @escaping (_ title: String) -> Void) {
        self.callBack = callBack
    }
}
