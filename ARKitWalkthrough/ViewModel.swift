//
//  ViewModel.swift
//  ARKitWalkthrough
//
//  Created by Para Molina, Jorge (Cognizant) on 3/22/19.
//  Copyright © 2019 Para Molina, Jorge (Cognizant). All rights reserved.
//

import Foundation
import ARKit

internal typealias UpdateSceneDebugOptions = (ARSCNDebugOptions) -> Void
internal typealias UpdateSceneConfiguration = (ARConfiguration) -> Void

/// View model for the main view controller
internal class ViewModel {

    var updateSceneDebugOptions: UpdateSceneDebugOptions?
    var updateSceneConfiguration: UpdateSceneConfiguration?
    var configuration: ARConfiguration = ARWorldTrackingConfiguration()
    var sessionOptions: ARSession.RunOptions = [.removeExistingAnchors]

    private var debugOptions: ARSCNDebugOptions = []


    /// Allows enabling and disabling world origin marker in the AR scene
    ///
    /// - Parameter enabled: true if the world origin should be shown, otherwise false
    func showWorldOrigin(_ enabled: Bool) { sendNewDebugOptions(enabled: enabled, option: .showWorldOrigin) }


    /// Allows enabling and disabling showing feature points in the AR scene
    ///
    /// - Parameter enabled: true if the feature points should be shown, otherwise false
    func showFeaturePoints(_ enabled: Bool) { sendNewDebugOptions(enabled: enabled, option: .showFeaturePoints) }

    private func sendNewDebugOptions(enabled: Bool, option: ARSCNDebugOptions) {
        if enabled {
            debugOptions.insert(option)
        } else {
            debugOptions.remove(option)
        }
        updateSceneDebugOptions?(debugOptions)
    }


    /// Allows enabling and disabling showing horizontal planes
    ///
    /// - Parameter enabled: true if the horizontal planes should be shown, otherwise false
    func showPlanes(_ enabled: Bool) {
        let worldTrackingConfiguration = ARWorldTrackingConfiguration()
        if enabled {
            worldTrackingConfiguration.planeDetection = .horizontal
        }
        updateSceneConfiguration?(worldTrackingConfiguration)
    }

    /// Invoked when a new anchor is added to the scene
    ///
    /// - Parameters:
    ///   - anchor: anchor that was added
    ///   - node: node created for the new anchor
    func anchorWasAdded(withAnchor anchor: ARAnchor, node: SCNNode) {

        // Check the anchor corresponds to a plane and if so, draw a plane in the scene with same dimensions and position
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }

        let width = CGFloat(planeAnchor.extent.x)
        let height = CGFloat(planeAnchor.extent.z)
        let plane = SCNPlane(width: width, height: height)
        plane.materials.first?.diffuse.contents = UIColor.lightGray.withAlphaComponent(0.2)

        let planeNode = SCNNode(geometry: plane)
        let x = CGFloat(planeAnchor.center.x)
        let y = CGFloat(planeAnchor.center.y)
        let z = CGFloat(planeAnchor.center.z)
        planeNode.position = SCNVector3(x,y,z)
        planeNode.eulerAngles.x = -.pi / 2

        node.addChildNode(planeNode)
    }

    /// Invoked when an existing anchor is updated in the scene
    ///
    /// - Parameters:
    ///   - anchor: anchor that was updated
    ///   - node: node for the  anchor
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
