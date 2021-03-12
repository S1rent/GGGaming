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
    
    public func goToGameDetail(gameData: Game) {
        let viewModel = GameDetailViewModel(gameData: gameData)
        let viewController = GameDetailViewController(viewModel: viewModel)
        UIApplication.topViewController()?.navigationController?.pushViewController(viewController, animated: true)
    }
}
