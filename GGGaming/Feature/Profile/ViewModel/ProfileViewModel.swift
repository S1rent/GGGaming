//
//  ProfileViewModel.swift
//  GGGaming
//
//  Created by IT Division on 11/03/21.
//

import Foundation
import RxSwift
import RxCocoa

final class ProfileViewModel {
    public struct Input {
        let loadTrigger: Driver<Void>
    }
    
    public struct Output {
        let data: Driver<ProfileModel>
    }
    
    public func transform(input: Input) -> Output {
        let profileData = input.loadTrigger.flatMapLatest { _ -> Driver<ProfileModel> in
            
            let user = UserService.shared.getUserSession()
            let educationList: [Experience] = self.initEducationList()
            
            let workingExperienceList: [Experience] = self.initWorkingExperienceList()
            
            let skillList: [Skill] = self.initSkillList()
            
            let name = user.userName ?? "-"
            let email = user.userEmail ?? "-"
            let profile: ProfileModel = Profile.shared.makeProfileModel(
                name: name,
                email: email,
                picture: UserService.shared.getUserPhoto(),
                educationList: educationList,
                workingExperienceList: workingExperienceList,
                skills: skillList
            )
            
            return Driver.just(profile)
        }
        
        return Output(data: profileData)
    }
    
    private func initEducationList() -> [Experience] {
        return [
            Profile.shared.makeExperienceModel(timeSpan: "2008 - 2011", institutionName: "SD Pelita Kudus"),
            Profile.shared.makeExperienceModel(timeSpan: "2011 - 2013", institutionName: "SD Santo Yakobus"),
            Profile.shared.makeExperienceModel(timeSpan: "2013 - 2016", institutionName: "SMP Santo Yakobus"),
            Profile.shared.makeExperienceModel(timeSpan: "2016 - 2019", institutionName: "SMA Santo Yakobus"),
            Profile.shared.makeExperienceModel(timeSpan: "2019 - Present", institutionName: "BINUS University")
        ]
    }
    
    private func initWorkingExperienceList() -> [Experience] {
        return [
            Profile.shared.makeExperienceModel(timeSpan: "2019 - 2020", institutionName: "Education Counselour for BINUS University"),
            Profile.shared.makeExperienceModel(timeSpan: "2020 - 2021", institutionName: "Associate Member for BINUS IT Division"),
            Profile.shared.makeExperienceModel(timeSpan: "2021 - Present", institutionName: "Junior Programmer for BINUS IT Division")
        ]
    }
    
    private func initSkillList() -> [Skill] {
        return [
            Profile.shared.makeSkillModel(skillName: "Android", progress: 70),
            Profile.shared.makeSkillModel(skillName: "ASP.NET", progress: 65),
            Profile.shared.makeSkillModel(skillName: "C", progress: 90),
            Profile.shared.makeSkillModel(skillName: "C#", progress: 65),
            Profile.shared.makeSkillModel(skillName: "CSS", progress: 80),
            Profile.shared.makeSkillModel(skillName: "HTML", progress: 80),
            Profile.shared.makeSkillModel(skillName: "Java", progress: 85),
            Profile.shared.makeSkillModel(skillName: "Javascript", progress: 70),
            Profile.shared.makeSkillModel(skillName: "Laravel", progress: 82),
            Profile.shared.makeSkillModel(skillName: "React", progress: 45),
            Profile.shared.makeSkillModel(skillName: "Swift", progress: 90),
            Profile.shared.makeSkillModel(skillName: "Vue", progress: 50)
        ]
    }
}
