//
//  AuthenticatedUser.swift
//  GGGaming
//
//  Created by IT Division on 18/03/21.
//

import Foundation

public struct AuthenticatedUser: Codable {
    var userID: String?
    var userPassword: String?
    var userName: String?
    var userEmail: String?
    var userPhotoURL: String?
    var userEducationList: [Experience]?
    var userExperienceList: [Experience]?
    var userSkillList: [Skill]?
    
    public enum CodingKeys: String, CodingKey {
        case userID = "session_userID"
        case userPassword = "session_userPassword"
        case userName = "session_userName"
        case userEmail = "session_userEmail"
        case userPhotoURL = "session_userPhotoURL"
        case userEducationList = "session_userEducationList"
        case userExperienceList = "session_userExperienceList"
        case userSkillList = "session_userSkillList"
    }
}
