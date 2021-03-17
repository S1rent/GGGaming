//
//  UserModel.swift
//  GGGaming
//
//  Created by IT Division on 17/03/21.
//

import Foundation

public struct UserModel {
    let userEmail: String?
    let userID: String?
    let userPassword: String?
    let userName: String?
    
    public init(
        email: String,
        id: String,
        password: String,
        name: String
    ) {
        self.userEmail = email
        self.userID = id
        self.userPassword = password
        self.userName = name
    }
}
