//
//  ProfileChangeViewModel.swift
//  GGGaming
//
//  Created by IT Division on 19/03/21.
//

import Foundation
import RxSwift
import RxCocoa

final class ProfileChangeViewModel {
    struct Input {
        let loadTrigger: Driver<Void>
        let nameRelay: Driver<String>
        let emailRelay: Driver<String>
        let urlRelay: Driver<String>
        let saveTrigger: Driver<Void>
    }
    
    struct Output {
        let data: Driver<AuthenticatedUser?>
        let success: Driver<String>
        let error: Driver<String>
    }
    
    public func transform(input: Input) -> Output {
        
        let profileData = Driver.combineLatest(input.nameRelay, input.emailRelay, input.urlRelay)
        
        let save = input.saveTrigger.withLatestFrom(profileData).map { tuple -> RegisterEnum in
            let trimmedName = tuple.0.trimmingCharacters(in: .whitespacesAndNewlines)
            let trimmedEmail = tuple.1.trimmingCharacters(in: .whitespacesAndNewlines)
            
            let emailValidation = self.validateEmail(email: trimmedEmail)
            
            if trimmedName.isEmpty {
                return RegisterEnum.errorNameEmpty
            } else if emailValidation != RegisterEnum.success {
                return emailValidation
            }
            
            UserService.shared.editProfile(name: trimmedName, email: trimmedEmail, photoURL: tuple.2)
            
            return RegisterEnum.success
        }
        
        let data = input.loadTrigger.map { _ -> AuthenticatedUser? in
            let user = UserService.shared.getUser()
            
            return user
        }.filter {
            $0 != nil
        }
        
        let success = save.filter {
            $0 == RegisterEnum.success
        }.map { _ in
            return "Successfully edited your account."
        }
        
        let error = save.filter {
            $0 != RegisterEnum.success
        }.map {
            $0.rawValue
        }
        
        return Output(
            data: data,
            success: success,
            error: error
        )
    }
    
    private func validateEmail(email: String) -> RegisterEnum {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let user = UserService.shared.getUser()
        
        if trimmedEmail.isEmpty {
            return RegisterEnum.errorEmailEmpty
        } else if trimmedEmail.filter({ $0 == "@" }).count != 1 {
            return RegisterEnum.errorEmailNoAt
        } else if trimmedEmail.filter({ $0 == "." }).count < 1 {
            return RegisterEnum.errorEmailNoDot
        } else if trimmedEmail[trimmedEmail.startIndex] == "@" || trimmedEmail[trimmedEmail.startIndex] == "." {
            return RegisterEnum.errorEmailStartAtOrDot
        } else if trimmedEmail[trimmedEmail.index(before: trimmedEmail.endIndex)] == "@" || trimmedEmail[trimmedEmail.index(before: trimmedEmail.endIndex)] == "." {
            return RegisterEnum.errorEmailEndAtOrDot
        } else if !UserCoreDataFunctionality.shared.getUser(email: trimmedEmail).isEmpty && trimmedEmail != user?.userEmail {
            return RegisterEnum.errorEmailExist
        }
        
        return RegisterEnum.success
    }
}
