//
//  UIView+Extension.swift
//  GGGaming
//
//  Created by IT Division on 11/03/21.
//

import Foundation
import UIKit

extension UIView {
    static var identifier: String {
        return String(describing: self)
    }
    
    static var uiNib: UINib {
        return UINib(nibName: self.identifier, bundle: nil)
    }
    
    func animateFadeIn() {
        UIView.animate(
            withDuration: 1.2,
            delay: 0.5,
            usingSpringWithDamping: 0.6,
            initialSpringVelocity: 0.1,
            options: [.curveEaseInOut],
            animations: {
                self.alpha = 1
                self.isHidden = false
        })
    }
    
    func animateFadeOut() {
        UIView.animate(
            withDuration: 1.2,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 1,
            options: [.curveEaseOut],
            animations: {
                self.alpha = 0
                self.isHidden = true
        })
    }
}
