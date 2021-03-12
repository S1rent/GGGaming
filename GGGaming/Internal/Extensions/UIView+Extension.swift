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
    
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
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
        })
    }
}
