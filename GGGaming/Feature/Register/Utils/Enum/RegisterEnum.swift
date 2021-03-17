//
//  RegisterEnum.swift
//  GGGaming
//
//  Created by IT Division on 17/03/21.
//

import Foundation

enum RegisterEnum: String {
    case errorPasswordEmpty = "Password cannot be empty."
    case errorPasswordLength = "Password length must be more than 6 characters."
    case errorPasswordCharacterType = "Password can only be filled with alphabet, number or symbols."
    case errorNameEmpty = "Name cannot be empty."
    case errorEmailEmpty = "Email cannot be empty."
    case errorEmailNoAt = "Email must contain one \'@\'."
    case errorEmailNoDot = "Email must contain at least one \'.\'"
    case errorEmailStartAtOrDot = "Email must not start with \'@\' or \'.\'."
    case errorEmailEndAtOrDot = "Email must not end with \'@\' or \'.\'"
    case errorFatal = "Something went wrong, please try again later."
    case success = "Successfully created your account."
}
