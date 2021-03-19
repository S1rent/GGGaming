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
        let itemName: Driver<String>
        let itemTerm: Driver<String>
        let itemProgressValue: Driver<String>
        let itemType: Driver<ProfileAddItemEnum>
        let addTrigger: Driver<Void>
    }
    
    public struct Output {
        let data: Driver<ProfileModel>
        let addSuccess: Driver<String>
        let addError: Driver<String>
    }
    
    public func transform(input: Input) -> Output {
        
        let newItemData = Driver.combineLatest(
            input.itemName,
            input.itemTerm,
            input.itemProgressValue,
            input.itemType
        )
        
        let addStatus = input.addTrigger.withLatestFrom(newItemData)
            .map { (name, term, progressValue, type) -> ProfileAddItemErrorEnum in
            let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
            let trimmedProgressValue = progressValue.trimmingCharacters(in: .whitespacesAndNewlines)
            let trimmedTerm = term.trimmingCharacters(in: .whitespacesAndNewlines)
            
            let status = { () -> ProfileAddItemErrorEnum in
                switch type {
                case .education:
                    return self.validateExperienceModel(trimmedName, trimmedTerm)
                case .skill:
                    return self.validateSkillModel(trimmedName, trimmedProgressValue)
                case .workingExperience:
                    return self.validateExperienceModel(trimmedName, trimmedTerm)
                }
            }
                
            if status() == ProfileAddItemErrorEnum.success {
                self.saveData(
                    name: trimmedName,
                    term: trimmedTerm,
                    progressValue: trimmedProgressValue,
                    type: type
                )
            }
                
            return status()
        }
        
        let profileData = input.loadTrigger.flatMapLatest { _ -> Driver<ProfileModel> in
            
            return Driver.just(self.makeProfileModel())
        }
        
        let addSuccess = addStatus.filter {
            $0 == ProfileAddItemErrorEnum.success
        }.map {
            $0.rawValue
        }
        
        let addError = addStatus.filter {
            $0 != ProfileAddItemErrorEnum.success
        }.map {
            $0.rawValue
        }
        
        return Output(
            data: profileData,
            addSuccess: addSuccess,
            addError: addError
        )
    }
}

extension ProfileViewModel {
    private func validateExperienceModel(_ name: String, _ term: String) -> ProfileAddItemErrorEnum {
        
        if name.isEmpty {
            return ProfileAddItemErrorEnum.errorAddItemNameEmpty
        } else if term.isEmpty {
            return ProfileAddItemErrorEnum.errorAddItemTermEmpty
        }
        
        return ProfileAddItemErrorEnum.success
    }
    
    private func validateSkillModel(_ name: String, _ progressValue: String) -> ProfileAddItemErrorEnum {
        
        if name.isEmpty {
            return ProfileAddItemErrorEnum.errorAddItemNameEmpty
        } else if progressValue.isEmpty {
            return ProfileAddItemErrorEnum.errorAddItemProgressValueEmpty
        }
        
        let intProgressValue = Int(progressValue) ?? -1
    
        if intProgressValue <= 0 || intProgressValue > 100 {
            return ProfileAddItemErrorEnum.errorAddItemProgressValueInapropriate
        }
        
        return ProfileAddItemErrorEnum.success
    }
    
    private func saveData(name: String, term: String, progressValue: String, type: ProfileAddItemEnum) {
        switch type {
        case .education:
            let model = Profile.shared.makeExperienceModel(timeSpan: term, institutionName: name)
            UserService.shared.appendUserEducationList(model)
        case .skill:
            let value = Double(progressValue) ?? 0
            let model = Profile.shared.makeSkillModel(skillName: name, progress: value)
            UserService.shared.appendUserSkillList(model)
        case .workingExperience:
            let model = Profile.shared.makeExperienceModel(timeSpan: term, institutionName: name)
            UserService.shared.appendUserWorkingExperienceList(model)
        }
    }
    
    private func makeProfileModel() -> ProfileModel {
        let user = UserService.shared.getUser()
        
        let profile: ProfileModel = Profile.shared.makeProfileModel(
            name: user?.userName ?? "-",
            email: user?.userEmail ?? "-",
            picture: user?.userPhotoURL ?? "-",
            educationList: user?.userEducationList ?? [],
            workingExperienceList: user?.userExperienceList ?? [],
            skills: user?.userSkillList ?? []
        )
        
        return profile
    }
}
