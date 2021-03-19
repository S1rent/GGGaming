//
//  LoginViewModel.swift
//  GGGaming
//
//  Created by IT Division on 17/03/21.
//

import Foundation
import RxSwift
import RxCocoa

final class LoginViewModel {
    struct Input {
        let loginTrigger: Driver<Void>
        let emailRelay: Driver<String>
        let passwordRelay: Driver<String>
    }
    
    struct Output {
        let error: Driver<String>
        let success: Driver<String>
    }
    
    public func transform(input: Input) -> Output {
        
        let userData = Driver.combineLatest(input.emailRelay, input.passwordRelay)
        
        let data = input.loginTrigger.withLatestFrom(userData).map { tuple -> LoginEnum in
            
            let emailValidation = self.validateEmail(email: tuple.0)
            let passwordValidation = self.validatePassword(password: tuple.1)
            let accountValidation = self.validateAccount(email: tuple.0, password: tuple.1)
            
            if emailValidation != LoginEnum.success {
                return emailValidation
            } else if passwordValidation != LoginEnum.success {
                return passwordValidation
            } else if accountValidation != LoginEnum.success {
                return accountValidation
            }
            
            guard let model = UserCoreDataFunctionality.shared.getUser(email: tuple.0).first
            else { return LoginEnum.errorFatal }
            
            UserService.shared.registerUserSession(data: model)
            
            return LoginEnum.success
        }
        
        let success = data.filter {
            $0 == LoginEnum.success
        }.map {
            $0.rawValue
        }
        
        let error = data.filter {
            $0 != LoginEnum.success
        }.map {
            $0.rawValue
        }
        return Output(
            error: error,
            success: success
        )
    }
    
    private func validatePassword(password: String) -> LoginEnum {
        let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedPassword.isEmpty {
            return LoginEnum.errorPasswordEmpty
        }
        
        return LoginEnum.success
    }
    
    private func validateEmail(email: String) -> LoginEnum {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedEmail.isEmpty {
            return LoginEnum.errorEmailEmpty
        } else if UserCoreDataFunctionality.shared.getUser(email: trimmedEmail).isEmpty {
            return LoginEnum.errorAccountNotFound
        }
        
        return LoginEnum.success
    }
    
    private func validateAccount(email: String, password: String) -> LoginEnum {
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedPassword = password.trimmingCharacters(in: .whitespacesAndNewlines)
        
        let userData = UserCoreDataFunctionality.shared.getUser(email: trimmedEmail)
        
        if userData.isEmpty { return LoginEnum.errorAccountNotFound }
        if userData.first?.userPassword != trimmedPassword {
            return LoginEnum.errorFailedAuthentication
        }
        
        return LoginEnum.success
    }
}
