//
//  MatricesHandler.swift
//  ARKitWalkthrough
//
//  Created by Para Molina, Jorge (Cognizant) on 5/15/19.
//  Copyright © 2019 Para Molina, Jorge (Cognizant). All rights reserved.
//

import Foundation
import ARKit
import SceneKit

/// Handler for demostrating the behavior of matricial transformation
internal class MatricesHandler: ObjectOnPlaneHandler {

    /// Returns 4 buttons. 3 of them allow activating / deactivating a tranformation
    /// matrix for translation, rotation and scale. The 4th button resets the transformation
    /// to the identity matrix
    func supplementaryOnScreenViews() -> [UIView]? {
        var views = [UIView]()

        let translationButton = makeMatrixButton(withIcon: "T")
        translationButton.addTarget(self, action: #selector(switchTranslation(sender:)), for: .touchUpInside)
        views.append(translationButton)

        let rotationButton = makeMatrixButton(withIcon: "R")
        rotationButton.addTarget(self, action: #selector(switchRotation(sender:)), for: .touchUpInside)
        views.append(rotationButton)

        let scaleButton = makeMatrixButton(withIcon: "S")
        scaleButton.addTarget(self, action: #selector(switchScale(sender:)), for: .touchUpInside)
        views.append(scaleButton)

        let initButton = makeMatrixButton(withIcon: "I")
        initButton.addTarget(self, action: #selector(initTransformation(sender:)), for: .touchUpInside)
        views.append(initButton)

        return views
    }

    /// Creates a button for the supplemenary views
    private func makeMatrixButton(withIcon icon: String) -> UIButton {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(icon, for: .normal)
        button.backgroundColor = UIColor.buttonBackground
        button.setTitleColor(UIColor.textSelectedSecondary, for: .selected)
        button.setTitleColor(UIColor.textDeselected, for: .normal)
        button.clipsToBounds = true
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: Constants.buttonSize),
            button.heightAnchor.constraint(equalToConstant: Constants.buttonSize)
            ])
        return button
    }

    /// Activates / deactivates translation matrix. It applies the reverse operation
    /// when deselected to restore the initial position
    @objc private func switchTranslation(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        var translation = matrix_identity_float4x4
        if sender.isSelected {
            translation = simd_float4x4(
                float4(1, 0, 0, 0),
                float4(0, 1, 0, 0),
                float4(0, 0, 1, 0),
                float4(0.1, 0, 0, 1)
            )
        } else {
            translation = simd_float4x4(
                float4(1, 0, 0, 0),
                float4(0, 1, 0, 0),
                float4(0, 0, 1, 0),
                float4(-0.1, 0, 0, 1)
            )
        }
        applyMatrix(translation)
    }

    /// Activates / deactivates rotation matrix. It applies the reverse operation
    /// when deselected to restore the initial orientation
    @objc private func switchRotation(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        let radians = 45 * Float.pi / 180
        var rotation = matrix_identity_float4x4
        if sender.isSelected {
            rotation = simd_float4x4(
                float4(cos(-radians), 0, sin(-radians), 0),
                float4(0, 1, 0, 0),
                float4(-sin(-radians), 0, cos(-radians), 0),
                float4(0, 0, 0, 1)
            )
        } else {
            rotation = simd_float4x4(
                float4(cos(radians), 0, sin(radians), 0),
                float4(0, 1, 0, 0),
                float4(-sin(radians), 0, cos(radians), 0),
                float4(0, 0, 0, 1)
            )
        }
        applyMatrix(rotation)
    }

    /// Activates / deactivates scale matrix. It applies the reverse operation
    /// when deselected to restore the initial size
    @objc private func switchScale(sender: UIButton) {
        sender.isSelected = !sender.isSelected
        var scale = matrix_identity_float4x4
        if sender.isSelected {
            scale = simd_float4x4(
                float4(2, 0, 0, 0),
                float4(0, 2, 0, 0),
                float4(0, 0, 2, 0),
                float4(0, 0, 0, 1)
            )
        } else {
            scale = simd_float4x4(
                float4(0.5, 0, 0, 0),
                float4(0, 0.5, 0, 0),
                float4(0, 0, 0.5, 0),
                float4(0, 0, 0, 0.5)
            )
        }
        applyMatrix(scale)
    }
    /// Resets the transformation matrix of the cup to affinity matrix
    @objc private func initTransformation(sender: UIButton) {
        SCNTransaction.animationDuration = 1
        cupNode.simdTransform = initialTransformation
    }

    /// Applies a new transformation on top of the current transformation
    private func applyMatrix(_ matrix: simd_float4x4) {
        SCNTransaction.animationDuration = 1
        cupNode.simdTransform = matrix * cupNode.simdTransform
    }

}

internal extension MatricesHandler {
    struct Constants {
        static let buttonSize: CGFloat = 44
    }
}
