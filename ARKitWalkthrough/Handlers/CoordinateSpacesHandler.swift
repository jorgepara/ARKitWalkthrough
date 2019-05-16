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

    private var playgroundFound = false

    func anchorWasAdded(withAnchor anchor: ARAnchor, node: SCNNode) {
        guard !playgroundFound, anchor is ARPlaneAnchor, let scene = SCNScene(named: "scene.scnassets/scene.scn") else { return }
        playgroundFound = true
        sceneUpdateQueue?.async {
            scene.rootNode.childNodes.forEach { [weak self] in
                node.addChildNode($0)
                guard let strongSelf = self else { return }
                strongSelf.addAxesInHierarchy(forNode: $0)
            }
        }
    }

    func anchorWasUpdated(withAnchor anchor: ARAnchor, node: SCNNode) {}

    func tappedWithHitTestResults(_ results: [SCNHitTestResult]) {
        print(results)
    }

    private func addAxesInHierarchy(forNode node: SCNNode) {
        node.childNodes.forEach { addAxesInHierarchy(forNode: $0) }
        if node.geometry != nil { node.addChildNode(makeAxes()) }
    }

    private func makeAxes() -> SCNNode {
        let originNode = SCNNode(geometry: SCNSphere(radius: 0.001))
        originNode.geometry?.materials.first?.diffuse.contents = UIColor.white

        let xAxisGeometry = SCNBox(width: 0.001, height: 0.001, length: 0.30, chamferRadius: 0)
        let xAxisNode = SCNNode(geometry: xAxisGeometry)
        xAxisNode.geometry?.materials.first?.diffuse.contents = UIColor.red
        xAxisNode.localTranslate(by: SCNVector3(x: 0.15, y: 0, z: 0))
        xAxisNode.eulerAngles = SCNVector3(0, Float.pi / 2, 0)
        let yAxisGeometry = SCNBox(width: 0.001, height: 0.001, length: 0.30, chamferRadius: 0)
        let yAxisNode = SCNNode(geometry: yAxisGeometry)
        yAxisNode.geometry?.materials.first?.diffuse.contents = UIColor.green
        yAxisNode.localTranslate(by: SCNVector3(x: 0, y: 0.15, z: 0))
        yAxisNode.eulerAngles = SCNVector3(Float.pi / 2, 0, 0)
        let zAxisGeometry = SCNBox(width: 0.001, height: 0.001, length: 0.30, chamferRadius: 0)
        let zAxisNode = SCNNode(geometry: zAxisGeometry)
        zAxisNode.geometry?.materials.first?.diffuse.contents = UIColor.blue
        zAxisNode.localTranslate(by: SCNVector3(x: 0, y: 0, z: 0.15))

        originNode.addChildNode(xAxisNode)
        originNode.addChildNode(yAxisNode)
        originNode.addChildNode(zAxisNode)

        return originNode
    }
}
