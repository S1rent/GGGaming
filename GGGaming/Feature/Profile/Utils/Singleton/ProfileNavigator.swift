//
//  ProfileNavigator.swift
//  GGGaming
//
//  Created by IT Division on 19/03/21.
//

import Foundation
import UIKit

class ProfileNavigator {
    public static let shared = ProfileNavigator()
    
    private init() { }
    
    func navigateToAddExperiencePopUp(
        callBack: @escaping ((_ name: String, _ term: String, _ type: ProfileAddItemEnum) -> Void),
        type: ProfileAddItemEnum
    ) {
        let viewController = ProfileAddExperiencePopUpViewController(
            addCallback: callBack,
            type: type
        )
        viewController.modalPresentationStyle = .overFullScreen
        
        UIApplication.topViewController()?.present(viewController, animated: true, completion: nil)
    }
    
    func navigateToAddSkillPopUp(
        callBack: @escaping ((_ name: String, _ progressValue: String, _ type: ProfileAddItemEnum) -> Void),
        type: ProfileAddItemEnum
    ) {
        let viewController = ProfileAddSkillPopUpViewController(
            addCallback: callBack,
            type: ProfileAddItemEnum.skill
        )
        viewController.modalPresentationStyle = .overFullScreen
        
        UIApplication.topViewController()?.present(viewController, animated: true, completion: nil)
    }
}
