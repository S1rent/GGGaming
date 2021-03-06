//
//  ProfileModel.swift
//  GGGaming
//
//  Created by IT Division on 11/03/21.
//

import Foundation

public struct ProfileModel {
    let name: String
    let email: String
    let picture: String
    let educationList: [Experience]
    let workingExperienceList: [Experience]
    let skills: [Skill]
    
    public init(name: String, email: String, picture: String, educationList: [Experience], workingExperienceList: [Experience], skills: [Skill]) {
        self.name = name
        self.email = email
        self.educationList = educationList
        self.workingExperienceList = workingExperienceList
        self.picture = picture
        self.skills = skills
    }
}

public struct Experience: Codable {
    let experienceID: String
    let timeSpan: String
    let institutionName: String
}

public struct Skill: Codable {
    let skillID: String
    let skillName: String
    let progress: Double
}

class Profile {
    
    static let shared = Profile()
    
    public init() { }
    
    public func makeExperienceModel(
        timeSpan: String,
        institutionName: String
    ) -> Experience {
        let model = Experience(experienceID: UUID().uuidString, timeSpan: timeSpan, institutionName: institutionName)
        
        return model
    }
    
    public func makeSkillModel(
        skillName: String,
        progress: Double
    ) -> Skill {
        let model = Skill(skillID: UUID().uuidString, skillName: skillName, progress: progress)
        
        return model
    }
    
    public func makeProfileModel(
        name: String,
        email: String,
        picture: String,
        educationList: [Experience],
        workingExperienceList: [Experience],
        skills: [Skill]
    ) -> ProfileModel {
        let model = ProfileModel(name: name, email: email, picture: picture, educationList: educationList, workingExperienceList: workingExperienceList, skills: skills)
        
        return model
    }
}
