//
//  GameNavigator.swift
//  GGGaming
//
//  Created by IT Division on 12/03/21.
//

import Foundation
import UIKit

class GameNavigator {
    public static let shared = GameNavigator()
    
    private init() { }
    
    public func navigateToGameDetail(gameData: Game) {
        let viewModel = GameDetailViewModel(gameData: gameData)
        let viewController = GameDetailViewController(gameData: gameData, viewModel: viewModel)
        
        UIApplication.topViewController()?.navigationController?.pushViewController(viewController, animated: true)
    }
    
    public func navigateToSearchedGameResultPage(gameData: [Game], searchedKey: String) {
        let viewModel = GameSearchResultViewModel(data: gameData)
        let viewController = GameSearchResultViewController(searchKey: searchedKey, viewModel: viewModel)
        
        UIApplication.topViewController()?.navigationController?.pushViewController(viewController, animated: true)
    }
    
    public func navigateToSearchedGameResultByDeveloperPage(developerData: Developer) {
        let viewModel = GameListByDeveloperViewModel(data: developerData)
        let viewController = GameListByDeveloperViewController(developerData: developerData, viewModel: viewModel)
        
        UIApplication.topViewController()?.navigationController?.pushViewController(viewController, animated: true)
    }
    
    public func navigateToDeveloperList() {
        let viewModel = GameDeveloperListViewModel()
        let viewController = GameDeveloperListViewController(viewModel: viewModel)
        
        UIApplication.topViewController()?.navigationController?.pushViewController(viewController, animated: true)
    }
}
