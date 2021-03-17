//
//  LoginEnum.swift
//  GGGaming
//
//  Created by IT Division on 17/03/21.
//

import Foundation

enum LoginEnum: String {
    case errorPasswordEmpty = "Password cannot be empty."
    case errorEmailEmpty = "Email cannot be empty."
    case errorAccountNotFound = "Account is not found."
    case errorFailedAuthentication = "Authentication failed, please check your email and password."
    case errorFatal = "Something went wrong, please try again later."
    case success = "Successfully created your account."
}
