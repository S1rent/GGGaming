//
//  ProfileViewController+Extension.swift
//  GGGaming
//
//  Created by IT Division on 19/03/21.
//

import Foundation
import UIKit

extension ProfileViewController {
    // popup function
    func presentInformation() {
        let alertController = UIAlertController(title: "Information", message: "Successfully logged out.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            
            UserService.shared.logout()
            let viewController = LoginViewController()
            let delegate = self.view.window?.windowScene?.delegate as? SceneDelegate
            delegate?.setRootViewController(viewController: viewController)
        })
        alertController.addAction(okAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showLogoutPopupConfirmation() {
        let alertController = UIAlertController(title: "Confirmation", message: "Are you sure you want logout ?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            
            self.presentInformation()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        UIApplication.topViewController()?.navigationController?.present(alertController, animated: true, completion: nil)
    }
}
