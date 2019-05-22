//
//  DebugHandler.swift
//  ARKitWalkthrough
//
//  Created by Para Molina, Jorge (Cognizant) on 3/22/19.
//  Copyright © 2019 Para Molina, Jorge (Cognizant). All rights reserved.
//

import Foundation
import ARKit

/// AR handler for showcase of debug options
internal class DebugHandler: ARHandler {

    lazy var configuration: ARConfiguration = {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        return configuration
    }()

    var sessionOptions: ARSession.RunOptions = [.removeExistingAnchors]
    var debugOptions: ARSCNDebugOptions = [.showWorldOrigin, .showFeaturePoints]

    var sceneUpdateQueue: DispatchQueue? = nil

    func anchorWasAdded(withAnchor anchor: ARAnchor, node: SCNNode) {

        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }

        let planeNode = planeAnchor.nodeRepresentation(withAlpha: 0.2)

        sceneUpdateQueue?.async {
            node.addChildNode(planeNode)
        }
    }

    func anchorWasUpdated(withAnchor anchor: ARAnchor, node: SCNNode) {

        guard let planeAnchor = anchor as?  ARPlaneAnchor,
            let planeNode = node.childNodes.first,
            let plane = planeNode.geometry as? SCNPlane
            else { return }

        let width = CGFloat(planeAnchor.extent.x)
        let height = CGFloat(planeAnchor.extent.z)
        plane.width = width
        plane.height = height

        let x = CGFloat(planeAnchor.center.x)
        let y = CGFloat(planeAnchor.center.y)
        let z = CGFloat(planeAnchor.center.z)

        planeNode.position = SCNVector3(x, y, z)
    }

}
