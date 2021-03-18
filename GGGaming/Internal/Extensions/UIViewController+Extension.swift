//
//  UIViewController+Extension.swift
//  GGGaming
//
//  Created by IT Division on 18/03/21.
//

import Foundation
import UIKit

extension UIViewController {
    func presentInformationPopup(title: String, message: String, callBack: @escaping (() -> Void) = {  }) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
            callBack()
        })
        alertController.addAction(okAction)
        
        UIApplication.topViewController()?.present(alertController, animated: true, completion: nil)
    }
}
