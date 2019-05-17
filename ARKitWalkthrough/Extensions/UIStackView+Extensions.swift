//
//  UIStackView+Extensions.swift
//  ARKitWalkthrough
//
//  Created by Para Molina, Jorge (Cognizant) on 5/17/19.
//  Copyright © 2019 Para Molina, Jorge (Cognizant). All rights reserved.
//

import Foundation
import UIKit

extension UIStackView {

    func removeAllArrangedSubviews() {

        let removedSubviews = arrangedSubviews.reduce([]) { (allSubviews, subview) -> [UIView] in
            self.removeArrangedSubview(subview)
            return allSubviews + [subview]
        }

        // Deactivate all constraints
        NSLayoutConstraint.deactivate(removedSubviews.flatMap({ $0.constraints }))

        // Remove the views from self
        removedSubviews.forEach({ $0.removeFromSuperview() })
    }
}

