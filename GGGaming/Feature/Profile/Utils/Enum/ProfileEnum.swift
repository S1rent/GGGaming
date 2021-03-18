//
//  ProfileEnum.swift
//  GGGaming
//
//  Created by IT Division on 18/03/21.
//

import Foundation

enum ProfileAddItemEnum {
    case education
    case skill
    case workingExperience
}

enum ProfileAddItemErrorEnum: String {
    case errorAddItemNameEmpty = "Name cannot be empty."
    case errorAddItemTermEmpty = "Term cannot be empty."
    case errorAddItemProgressValueEmpty = "Progress value cannot be empty."
    case errorAddItemProgressValueInapropriate = "Progress value must be at least 0 and also smaller or equal than 100."
    case fatalError = "Something went wrong, please try again later."
    case success = "Item successfully added."
}
