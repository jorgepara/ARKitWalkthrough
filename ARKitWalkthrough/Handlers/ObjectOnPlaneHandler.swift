//
//  ObjectOnPlaneHandler.swift
//  ARKitWalkthrough
//
//  Created by Para Molina, Jorge (Cognizant) on 5/16/19.
//  Copyright © 2019 Para Molina, Jorge (Cognizant). All rights reserved.
//

import Foundation
import ARKit

/// Base handler for find a plane and adding a virtual object, on top of that
/// other concepts will be demostrated
internal class ObjectOnPlaneHandler: ARHandler {

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

    let initialTransformation = simd_float4x4(
        float4(1, 0, 0, 0),
        float4(0, 1, 0, 0),
        float4(0, 0, 1, 0),
        float4(0, 0.05, 0, 1))

    private static let mininumLenght: CGFloat = 0.3

    private var playgroundFound =  false

    func anchorWasAdded(withAnchor anchor: ARAnchor, node: SCNNode) {}

    func anchorWasUpdated(withAnchor anchor: ARAnchor, node: SCNNode) {
        guard !playgroundFound else { return }

        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }

        let width = CGFloat(planeAnchor.extent.x)
        let height = CGFloat(planeAnchor.extent.z)

        guard width >= ObjectOnPlaneHandler.mininumLenght, height >= ObjectOnPlaneHandler.mininumLenght  else { return }

        playgroundFound = true

        let planeNode = planeAnchor.nodeRepresentation()

        sceneUpdateQueue?.async { [weak self] in
            guard let self = self else { return }
            node.addChildNode(planeNode)
            node.addChildNode(self.cupNode)
        }
    }

}
