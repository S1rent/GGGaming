//
//  FavoriteCoreDataFunctionality.swift
//  GGGaming
//
//  Created by IT Division on 19/03/21.
//

import Foundation
import UIKit
import CoreData

class FavoriteCoreDataFunctionality {
    
    public static let shared = FavoriteCoreDataFunctionality()
    private init() { }
    
    func insertFavorite(game: Game) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        if let entity = NSEntityDescription.entity(forEntityName: "Favorite", in: managedContext) {
            let create = NSManagedObject(entity: entity, insertInto: managedContext)
            
            create.setValue(game.gameID ?? 0, forKey: "gameID")
            create.setValue(game.gameName ?? "", forKey: "gameName")
            create.setValue(game.gameImagePreview ?? "", forKey: "gameImageURL")
            create.setValue(game.gameReleaseDate ?? "", forKey: "gameReleaseDate")
            create.setValue(game.gameRating ?? 0, forKey: "gameRating")
            
            do {
                try managedContext.save()
            } catch {
                return false
            }
        }
        return true
    }
    
    func insertFavorite(game: GameDetailResponseWrapper) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        if let entity = NSEntityDescription.entity(forEntityName: "Favorite", in: managedContext) {
            let create = NSManagedObject(entity: entity, insertInto: managedContext)
            
            create.setValue(game.gameID ?? 0, forKey: "gameID")
            create.setValue(game.gameName ?? "", forKey: "gameName")
            create.setValue(game.gameImagePreview ?? "", forKey: "gameImageURL")
            create.setValue(game.gameReleaseDate ?? "", forKey: "gameReleaseDate")
            create.setValue(game.gameRating ?? 0, forKey: "gameRating")
            
            do {
                try managedContext.save()
            } catch {
                return false
            }
        }
        return true
    }
    
    func getFavorites() -> [FavoriteModel] {
        var favorites: [FavoriteModel] = []
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorite")
        
        do {
            guard let result = try managedContext.fetch(fetchRequest) as? [NSManagedObject] else { return [] }
            
            result.forEach { game in
                favorites.append(
                    FavoriteModel(
                        gameID: game.value(forKey: "gameID") as? Int ?? 0,
                        gameName: game.value(forKey: "gameName") as? String ?? "",
                        gameReleaseDate: game.value(forKey: "gameReleaseDate") as? String ?? "",
                        gamePictureURL: game.value(forKey: "gameImageURL") as? String ?? "",
                        gameRating: game.value(forKey: "gameRating") as? Double ?? 0
                    )
                )
            }
        } catch {
            return []
        }
        
        return favorites
    }
    
    func removeFavorite(_ id: Int) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Favorite")
        fetchRequest.predicate = NSPredicate(format: "gameID = %ld", id)
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            if result.isEmpty {
                return false
            }
            
            if let dataToRemove = result[0] as? NSManagedObject {
                managedContext.delete(dataToRemove)
                
                try managedContext.save()
            }
        } catch {
            return false
        }
        
        return true
    }
    
    func getGame(id: Int) -> Bool {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let query = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorite")
        
        query.predicate = NSPredicate(format: "gameID = %ld", id)
        
        do {
            guard let result = try managedContext.fetch(query) as? [NSManagedObject] else { return false }
            
            if result.isEmpty { return false}
        } catch {
            return false
        }
        
        return true
    }
}
