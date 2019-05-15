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

internal class MatricesHandler: ARHandler {

    lazy var configuration: ARConfiguration = {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        return configuration
    }()

    lazy var cupNode: SCNNode = {
        let cylinder = SCNCylinder(radius: 0.05, height: 0.1)
        cylinder.materials.first?.diffuse.contents = UIImage(named: "logo_cognizant.jpg") ?? UIColor.blue
        let cupNode = SCNNode(geometry: cylinder)
        cupNode.simdTransform = initialTransformation
        return cupNode
    }()

    var sessionOptions: ARSession.RunOptions = [.removeExistingAnchors]
    var debugOptions: ARSCNDebugOptions = []
    var sceneUpdateQueue: DispatchQueue? = nil

    private static let mininumLenght: CGFloat = 0.3

    private let initialTransformation = simd_float4x4(
        float4(1, 0, 0, 0),
        float4(0, 1, 0, 0),
        float4(0, 0, 1, 0),
        float4(0, 0.05, 0, 1))

    private var playgroundFound =  false

    func anchorWasAdded(withAnchor anchor: ARAnchor, node: SCNNode) {}

    func anchorWasUpdated(withAnchor anchor: ARAnchor, node: SCNNode) {
        guard !playgroundFound else { return }

        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }

        let width = CGFloat(planeAnchor.extent.x)
        let height = CGFloat(planeAnchor.extent.z)

        guard width >= MatricesHandler.mininumLenght, height >= MatricesHandler.mininumLenght  else { return }

        playgroundFound = true

        let planeNode = planeAnchor.nodeRepresentation()

        sceneUpdateQueue?.async { [weak self] in
            guard let self = self else { return }
            node.addChildNode(planeNode)
            node.addChildNode(self.cupNode)
        }
    }

    func tappedWithHitTestResults(_ results: [SCNHitTestResult]) {
        results.forEach { print($0) }
    }

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
    @objc private func initTransformation(sender: UIButton) {
        SCNTransaction.animationDuration = 1
        cupNode.simdTransform = initialTransformation
    }

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
