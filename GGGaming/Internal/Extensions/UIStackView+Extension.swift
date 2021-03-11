//
//  UIStackView+Extension.swift
//  GGGaming
//
//  Created by IT Division on 11/03/21.
//

import Foundation
import UIKit

extension UIStackView {
    func safelyRemoveAllArrangedSubviews() {
        let removedSubviews = arrangedSubviews.reduce([]) { (allSubviews, subview) -> [UIView] in
            self.removeArrangedSubview(subview)
            return allSubviews + [subview]
        }
        
        NSLayoutConstraint.deactivate(removedSubviews.flatMap({ $0.constraints }))
    
        removedSubviews.forEach({ $0.removeFromSuperview() })
    }
}
