//
//  UserService.swift
//  GGGaming
//
//  Created by IT Division on 16/03/21.
//

import Foundation

public class UserService {
    public static let shared = UserService()

    private var userData: AuthenticatedUser?
    private let userDefaultsKey = "gggaming_authenticated_user"
    
    private init() {
        if let rawData = UserDefaults.standard.value(forKey: userDefaultsKey) as? Data {
            self.userData = try? JSONDecoder().decode(AuthenticatedUser.self, from: rawData)
        }
    }
    
    public func logout() {
        self.userData = nil
        
        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
        UserDefaults.standard.synchronize()
    }
    
    public func appendUserEducationList(_ education: Experience) {
        var user = UserService.shared.getUser()
        user?.userEducationList?.append(education)
        UserService.shared.setUser(user)
    }
    
    public func appendUserWorkingExperienceList(_ experience: Experience) {
        var user = UserService.shared.getUser()
        user?.userExperienceList?.append(experience)
        UserService.shared.setUser(user)
    }
    
    public func appendUserSkillList(_ skill: Skill) {
        var user = UserService.shared.getUser()
        user?.userSkillList?.append(skill)
        UserService.shared.setUser(user)
    }
    
    public func registerUserSession(data: UserModel) {
        if var user = UserService.shared.getUser() {
            user.userID = data.userID
            user.userEmail = data.userEmail
            user.userPassword = data.userPassword
            user.userName = data.userName
            
            UserService.shared.setUser(user)
        } else {
            let user = AuthenticatedUser(
                userID: data.userID,
                userPassword: data.userPassword,
                userName: data.userName,
                userEmail: data.userEmail,
                userPhotoURL: "",
                userEducationList: [],
                userExperienceList: [],
                userSkillList: []
            )
            
            UserService.shared.setUser(user)
        }
        
    }
    
    public func setUser(_ user: AuthenticatedUser?) {
        self.userData = user
        if let encodedData = try? JSONEncoder().encode(self.userData) {
            UserDefaults.standard.set(encodedData, forKey: userDefaultsKey)
            UserDefaults.standard.synchronize()
        }
    }
    
    public func getUser() -> AuthenticatedUser? {
        return self.userData
    }
}
