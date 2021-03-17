//
//  UserCoreDataFunctionality.swift
//  GGGaming
//
//  Created by IT Division on 17/03/21.
//

import Foundation
import UIKit
import CoreData

class UserCoreDataFunctionality {
    
    public static let shared = UserCoreDataFunctionality()
    private init() { }
    
    func createUserData(userData: UserModel) -> RegisterEnum {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return RegisterEnum.errorFatal }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        if let userEntity = NSEntityDescription.entity(forEntityName: "User", in: managedContext) {
            let create = NSManagedObject(entity: userEntity, insertInto: managedContext)
            
            create.setValue(userData.userEmail ?? "", forKey: "userEmail")
            create.setValue(userData.userPassword ?? "", forKey: "userID")
            create.setValue(userData.userName ?? "", forKey: "userName")
            create.setValue(userData.userPassword ?? "", forKey: "userPassword")
            
            do {
                try managedContext.save()
            } catch {
                return RegisterEnum.errorFatal
            }
        }
        return RegisterEnum.success
    }
    
    func getUser(email: String) -> [UserModel] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return [] }
        let managedContext = appDelegate.persistentContainer.viewContext
 
        var users: [UserModel] = []
        let query = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        query.predicate = NSPredicate(format: "userEmail = %@", email)
        
        do {
            guard let result = try managedContext.fetch(query) as? [NSManagedObject] else { return [] }
            
            result.forEach { user in
                let model = UserModel(
                    email: user.value(forKey: "userEmail") as? String ?? "",
                    id: user.value(forKey: "userID") as? String ?? "",
                    password: user.value(forKey: "userPassword") as? String ?? "",
                    name: user.value(forKey: "userName") as? String ?? ""
                )
                users.append(model)
            }
        } catch let error {
            print(error)
        }
        
        return users
    }
}
