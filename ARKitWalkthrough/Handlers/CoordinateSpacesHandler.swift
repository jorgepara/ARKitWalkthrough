//
//  CoordinateSpacesHandler.swift
//  ARKitWalkthrough
//
//  Created by Para Molina, Jorge (Cognizant) on 5/16/19.
//  Copyright © 2019 Para Molina, Jorge (Cognizant). All rights reserved.
//

import Foundation
import ARKit
import SceneKit

internal class CoordinateSpacesHandler: ARHandler {

    lazy var configuration: ARConfiguration = {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        return configuration
    }()

    var sessionOptions: ARSession.RunOptions = [.removeExistingAnchors]
    var debugOptions: ARSCNDebugOptions = []
    var sceneUpdateQueue: DispatchQueue? = nil

    func anchorWasAdded(withAnchor anchor: ARAnchor, node: SCNNode) {

    }

    func anchorWasUpdated(withAnchor anchor: ARAnchor, node: SCNNode) {}

    func tappedWithHitTestResults(_ results: [SCNHitTestResult]) {
        print(results)
    }
}
