//
//  MatricesHandler.swift
//  ARKitWalkthrough
//
//  Copyright © 2019-present Para Molina, Jorge. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation
import ARKit
import SceneKit

/// Handler for demostrating the behavior of matricial transformation
internal class MatricesHandler: ObjectOnPlaneHandler {

    private var translationButton: UIButton?
    private var rotationButton: UIButton?
    private var scaleButton: UIButton?

    /// Returns 4 buttons. 3 of them allow activating / deactivating a tranformation
    /// matrix for translation, rotation and scale. The 4th button resets the transformation
    /// to the identity matrix
    override func supplementaryOnScreenViews() -> [UIView]? {
        var views = [UIView]()

        let translationButton = OnScreenButton(withIcon: "Traslation")
        translationButton.addTarget(self, action: #selector(switchTranslation(sender:)), for: .touchUpInside)
        views.append(translationButton)
        self.translationButton = translationButton

        let rotationButton = OnScreenButton(withIcon: "Rotation")
        rotationButton.addTarget(self, action: #selector(switchRotation(sender:)), for: .touchUpInside)
        views.append(rotationButton)
        self.rotationButton = rotationButton

        let scaleButton = OnScreenButton(withIcon: "Scale")
        scaleButton.addTarget(self, action: #selector(switchScale(sender:)), for: .touchUpInside)
        views.append(scaleButton)
        self.scaleButton = scaleButton

        let resetButton = OnScreenButton(withIcon: "Reset")
        resetButton.addTarget(self, action: #selector(resetTransformation(sender:)), for: .touchUpInside)
        views.append(resetButton)

        return views
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
    @objc private func resetTransformation(sender: UIButton) {
        SCNTransaction.animationDuration = 1
        cupNode.simdTransform = matrix_identity_float4x4
        translationButton?.isSelected = false
        rotationButton?.isSelected = false
        scaleButton?.isSelected = false
    }

    /// Applies a new transformation on top of the current transformation
    private func applyMatrix(_ matrix: simd_float4x4) {
        SCNTransaction.animationDuration = 1
        cupNode.simdTransform = matrix * cupNode.simdTransform
    }

}
