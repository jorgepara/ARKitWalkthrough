//
//  OnScreenButton.swift
//  ARKitWalkthrough
//
//  Created by Para Molina, Jorge (Cognizant) on 5/17/19.
//  Copyright © 2019 Para Molina, Jorge (Cognizant). All rights reserved.
//

import UIKit

class OnScreenButton: UIButton {

    override var isSelected: Bool {
        didSet {
            print(isSelected)
        }
    }

    private static let buttonSize: CGFloat = 44
    private static let imageInsets: CGFloat = 5

    init(withIcon icon: String) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        imageEdgeInsets = UIEdgeInsets(top: OnScreenButton.imageInsets, left: OnScreenButton.imageInsets, bottom: OnScreenButton.imageInsets, right: OnScreenButton.imageInsets)
        if let imageSelected = UIImage(named: icon + "Selected"), let imageDeselected = UIImage(named: icon + "Deselected") {
            setImage(imageSelected, for: [.selected, .highlighted])
            setImage(imageSelected, for: .selected)
            setImage(imageSelected, for: .highlighted)
            setImage(imageDeselected, for: [])
        } else {
            setTitle(icon, for: .normal)
            setTitleColor(UIColor.textSelectedSecondary, for: .selected)
            setTitleColor(UIColor.textDeselected, for: .normal)
        }
        backgroundColor = UIColor.buttonBackground
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
