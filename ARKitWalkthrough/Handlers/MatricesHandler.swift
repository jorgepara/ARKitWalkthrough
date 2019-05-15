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

    private static let mininumLenght: CGFloat = 0.3

    private var playgroundFound =  false

    lazy var configuration: ARConfiguration = {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        return configuration
    }()

    lazy var cupNode: SCNNode = {
        let cylinder = SCNCylinder(radius: 0.05, height: 0.1)
        cylinder.materials.first?.diffuse.contents = UIColor.blue
        let cupNode = SCNNode(geometry: cylinder)
        cupNode.position = SCNVector3(0,0.05,0)
        return cupNode
    }()

    var sessionOptions: ARSession.RunOptions = [.removeExistingAnchors]
    var debugOptions: ARSCNDebugOptions = []
    var sceneUpdateQueue: DispatchQueue? = nil

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
}
