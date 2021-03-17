//
//  RegisterViewModel.swift
//  GGGaming
//
//  Created by IT Division on 17/03/21.
//

import Foundation
import RxSwift
import RxCocoa

final class RegisterViewModel {
    struct Input {
        let submitTrigger: Driver<Void>
        let nameTrigger: Driver<String>
        let emailTrigger: Driver<String>
        let passwordTrigger: Driver<String>
    }
    
    struct Output {
        let success: Driver<String>
        let error: Driver<String>
    }
    
    public func transform(input: Input) -> Output {
        
        let userData = Driver.combineLatest(input.nameTrigger, input.emailTrigger, input.passwordTrigger)
        
        let data = input.submitTrigger.withLatestFrom(userData).map { tuple -> RegisterEnum in
            
            let nameValidation = self.validateName(name: tuple.0)
            let emailValidation = self.validateEmail(email: tuple.1)
            let passwordValidation = self.validatePassword(password: tuple.2)
            let model: UserModel = UserModel(
                email: tuple.1,
                id: UUID().uuidString,
                password: tuple.2,
                name: tuple.1
            )
            
            if nameValidation != RegisterEnum.success {
                return nameValidation
            } else if emailValidation != RegisterEnum.success {
                return emailValidation
            } else if passwordValidation != RegisterEnum.success {
                return passwordValidation
            } else if UserCoreDataFunctionality.shared.createUserData(userData: model) != RegisterEnum.success {
                return RegisterEnum.errorFatal
            }
            
            UserService.shared.registerUserSession(user: model)
            
            return RegisterEnum.success
        }
        
        let success = data.filter {
            $0 == RegisterEnum.success
        }.map {
            $0.rawValue
        }
        
        let error = data.filter {
            $0 != RegisterEnum.success
        }.map {
            $0.rawValue
        }
        
        return Output(
            success: success,
            error: error
        )
    }
    
    private func validatePassword(password: String) -> RegisterEnum {
        let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedPassword.isEmpty {
            return RegisterEnum.errorPasswordEmpty
        } else if trimmedPassword.count <= 6 {
            return RegisterEnum.errorPasswordLength
        } else if !trimmedPassword.isAlphanumeric {
            return RegisterEnum.errorPasswordCharacterType
        }
        
        return RegisterEnum.success
    }
    
    private func validateName(name: String) -> RegisterEnum {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedName.isEmpty {
            return RegisterEnum.errorNameEmpty
        }
        
        return RegisterEnum.success
    }
    
    private func validateEmail(email: String) -> RegisterEnum {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedEmail.isEmpty {
            return RegisterEnum.errorEmailEmpty
        } else if trimmedEmail.filter({ $0 == "@" }).count != 1 {
            return RegisterEnum.errorEmailNoAt
        } else if trimmedEmail.filter({ $0 == "." }).count != 1 {
            return RegisterEnum.errorEmailNoDot
        } else if trimmedEmail[trimmedEmail.startIndex] == "@" || trimmedEmail[trimmedEmail.startIndex] == "." {
            return RegisterEnum.errorEmailStartAtOrDot
        } else if trimmedEmail[trimmedEmail.index(before: trimmedEmail.endIndex)] == "@" || trimmedEmail[trimmedEmail.index(before: trimmedEmail.endIndex)] == "." {
            return RegisterEnum.errorEmailEndAtOrDot
        } else if !UserCoreDataFunctionality.shared.getUser(email: trimmedEmail).isEmpty {
            return RegisterEnum.errorEmailExist
        }
        
        return RegisterEnum.success
    }
}
