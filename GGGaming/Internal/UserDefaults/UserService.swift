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
    
    func logout() {
        self.userData = nil
        
        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
        UserDefaults.standard.synchronize()
    }
    
    func appendUserEducationList(_ education: Experience) {
        var user = UserService.shared.getUser()
        user?.userEducationList?.append(education)
        UserService.shared.setUser(user)
    }
    
    func appendUserWorkingExperienceList(_ experience: Experience) {
        var user = UserService.shared.getUser()
        user?.userExperienceList?.append(experience)
        UserService.shared.setUser(user)
    }
    
    func appendUserSkillList(_ skill: Skill) {
        var user = UserService.shared.getUser()
        user?.userSkillList?.append(skill)
        UserService.shared.setUser(user)
    }
    
    func editProfile(name: String, email: String, photoURL: String) {
        var user = UserService.shared.getUser()
        user?.userName = name
        user?.userEmail = email
        user?.userPhotoURL = photoURL
        UserService.shared.setUser(user)
    }
    
    func removeSkillFromSkillList(_ skill: Skill) {
        var user = UserService.shared.getUser()
        let filteredSkills = user?.userSkillList?.filter { $0.skillID != skill.skillID }
        user?.userSkillList = filteredSkills
        UserService.shared.setUser(user)
    }
    
    func removeEducationFromEducationList(_ education: Experience) {
        var user = UserService.shared.getUser()
        let filteredEducationList = user?.userEducationList?.filter { $0.experienceID != education.experienceID }
        user?.userEducationList = filteredEducationList
        UserService.shared.setUser(user)
    }
    
    func removeExperienceFromExperienceList(_ experience: Experience) {
        var user = UserService.shared.getUser()
        let filteredExperienceList = user?.userExperienceList?.filter { $0.experienceID != experience.experienceID }
        user?.userExperienceList = filteredExperienceList
        UserService.shared.setUser(user)
    }
    
    func registerUserSession(data: UserModel) {
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
    
    func setUser(_ user: AuthenticatedUser?) {
        self.userData = user
        if let encodedData = try? JSONEncoder().encode(self.userData) {
            UserDefaults.standard.set(encodedData, forKey: userDefaultsKey)
            UserDefaults.standard.synchronize()
        }
    }
    
    func getUser() -> AuthenticatedUser? {
        return self.userData
    }
}
