//
//  HomeNavigator.swift
//  GGGaming
//
//  Created by IT Division on 14/03/21.
//

import Foundation
import UIKit

class HomeNavigator {
    
    public static let shared = HomeNavigator()
    
    private init() { }
    
    public func navigateToSearchedGameResultPage(gameData: [Game], searchedKey: String) {
        let viewModel = GameSearchResultViewModel(data: gameData)
        let viewController = GameSearchResultViewController(searchKey: searchedKey, viewModel: viewModel)
        
        UIApplication.topViewController()?.navigationController?.pushViewController(viewController, animated: true)
    }
}
