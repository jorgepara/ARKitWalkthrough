//
//  OnScreenButton.swift
//  ARKitWalkthrough
//
//  Created by Para Molina, Jorge (Cognizant) on 5/17/19.
//  Copyright © 2019 Para Molina, Jorge (Cognizant). All rights reserved.
//

import UIKit

class OnScreenButton: UIButton {

    private static let buttonSize: CGFloat = 44

    init(withIcon icon: String) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        setTitle(icon, for: .normal)
        backgroundColor = UIColor.buttonBackground
        setTitleColor(UIColor.textSelectedSecondary, for: .selected)
        setTitleColor(UIColor.textDeselected, for: .normal)
        clipsToBounds = true
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: OnScreenButton.buttonSize),
            heightAnchor.constraint(equalToConstant: OnScreenButton.buttonSize)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
