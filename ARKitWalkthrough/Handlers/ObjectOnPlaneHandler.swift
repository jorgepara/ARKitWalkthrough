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
        let cupNode = SCNNode(geometry: nil)
        guard let scene = SCNScene(named: "CupSceneAssets.scnassets/glass.scn") else { return cupNode }
        sceneUpdateQueue?.async {
            scene.rootNode.childNodes.forEach { [weak self] in
                cupNode.addChildNode($0)
            }
        }
        return cupNode
    }()

    weak var playgroundNode: SCNNode?

    var sessionOptions: ARSession.RunOptions = [.removeExistingAnchors]
    var debugOptions: ARSCNDebugOptions = []
    var sceneUpdateQueue: DispatchQueue? = nil

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
        playgroundNode = planeNode

        sceneUpdateQueue?.async { [weak self] in
            guard let self = self else { return }
            node.addChildNode(planeNode)
            node.addChildNode(self.cupNode)
        }
    }

    func supplementaryOnScreenViews() -> [UIView]? { return nil }
    func tappedWithHitTestResults(_ results: [SCNHitTestResult]) {}
    func longPressedStartedWithHitTestResults(_ results: [SCNHitTestResult]) {}
    func longPressedChangedWithHitTestResults(_ results: [SCNHitTestResult], onScreenTranslation traslation: CGPoint) {}
    func longPressedFinished() {}

}
