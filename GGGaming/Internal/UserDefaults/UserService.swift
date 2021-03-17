//
//  UserService.swift
//  GGGaming
//
//  Created by IT Division on 16/03/21.
//

import Foundation

enum UserDefaultsKey: String {
    case userID = "session_userID"
    case userPassword = "session_userPassword"
    case userName = "session_userName"
    case userEmail = "session_userEmail"
    case userPhotoURL = "session_userPhotoURL"
}

class UserService {
    
    public static let shared = UserService()
    
    private init() { }
    
    func registerUserSession(user: UserModel) {
        UserDefaults.standard.set(user.userID, forKey: UserDefaultsKey.userID.rawValue)
        UserDefaults.standard.set(user.userPassword, forKey: UserDefaultsKey.userPassword.rawValue)
        UserDefaults.standard.set(user.userName, forKey: UserDefaultsKey.userName.rawValue)
        UserDefaults.standard.set(user.userEmail, forKey: UserDefaultsKey.userEmail.rawValue)
    }
    
    func getUserSession() -> UserModel {
        let id = UserDefaults.standard.string(forKey: UserDefaultsKey.userID.rawValue) ?? ""
        let password = UserDefaults.standard.string(forKey: UserDefaultsKey.userPassword.rawValue) ?? ""
        let name = UserDefaults.standard.string(forKey: UserDefaultsKey.userName.rawValue) ?? ""
        let email = UserDefaults.standard.string(forKey: UserDefaultsKey.userEmail.rawValue) ?? ""
        return UserModel(
            email: email,
            id: id,
            password: password,
            name: name
        )
    }
}
