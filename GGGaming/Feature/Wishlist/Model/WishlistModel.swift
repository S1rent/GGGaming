//
//  WishlistModel.swift
//  GGGaming
//
//  Created by IT Division on 15/03/21.
//

import Foundation

class Wishlist {
    var gameWishList: [Game] = []
    
    public static let shared = Wishlist()
    private init() { }
    
    public func getWishList() -> [Game] {
        return self.gameWishList
    }
    
    public func addGameToWishList(game: Game) {
        self.gameWishList.append(game)
    }
    
    public func removeGameFromWishList(game: Game) {
        self.gameWishList = self.gameWishList.filter { $0.gameID != game.gameID }
    }
    
    public func isGameInsideWishList(gameData: Game) -> Bool {
        for game in self.gameWishList {
            if game.gameID == gameData.gameID {
                return true
            }
        }
        return false
    }
}
