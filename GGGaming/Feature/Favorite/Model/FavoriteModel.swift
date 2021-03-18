//
//  FavoriteModel.swift
//  GGGaming
//
//  Created by IT Division on 15/03/21.
//

import Foundation

class FavoriteModel {
    var favoriteGame: [Game] = []
    
    public static let shared = FavoriteModel()
    private init() { }
    
    public func getWishList() -> [Game] {
        return self.favoriteGame
    }
    
    public func addGameToWishList(game: Game) {
        self.favoriteGame.append(game)
    }
    
    public func removeGameFromWishList(game: Game) {
        self.favoriteGame = self.favoriteGame.filter { $0.gameID != game.gameID }
    }
    
    public func isGameInsideWishList(gameData: Game) -> Bool {
        for game in self.favoriteGame where game.gameID == gameData.gameID {
            return true
        }
        return false
    }
}
