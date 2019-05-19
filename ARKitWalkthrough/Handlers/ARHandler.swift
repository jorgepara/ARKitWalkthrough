//
//  ARHandler.swift
//  ARKitWalkthrough
//
//  Created by Para Molina, Jorge (Cognizant) on 4/23/19.
//  Copyright © 2019 Para Molina, Jorge (Cognizant). All rights reserved.
//

import Foundation
import ARKit

/// Protocol for the AR handlers that will define the configuration
/// of the AR scene and the behavior for event management
internal protocol ARHandler {

    var configuration: ARConfiguration { get }
    var sessionOptions: ARSession.RunOptions { get }
    var debugOptions: ARSCNDebugOptions { get }
    var sceneUpdateQueue: DispatchQueue? { get set }


    /// Invoked when a new anchor is added to the scene
    ///
    /// - Parameters:
    ///   - anchor: anchor that was added
    ///   - node: node created for the new anchor
    func anchorWasAdded(withAnchor anchor: ARAnchor, node: SCNNode)
    /// Invoked when an existing anchor is updated in the scene
    ///
    /// - Parameters:
    ///   - anchor: anchor that was updated
    ///   - node: node for the  anchor
    func anchorWasUpdated(withAnchor anchor: ARAnchor, node: SCNNode)
    /// Invoked when there is a tap and a hit test produced results
    ///
    /// - Parameter results: results of the hit test
    func tappedWithHitTestResults(_ results: [SCNHitTestResult])
    /// Invoked when a long press starts, hit test results can be empty
    ///
    /// - Parameter results: results of the hit test, it can be empty if there are no hits
    func longPressedStartedWithHitTestResults(_ results: [SCNHitTestResult])
    /// Invoked when a long press changes, hit test results can be empty
    ///
    /// - Parameter results: results of the hit test, it can be empty if there are no hits
    func longPressedChangedWithHitTestResults(_ results: [SCNHitTestResult], onScreenTranslation traslation: CGPoint)
    /// Invoked when a long press finishes, hit test results can be empty
    func longPressedFinished()
    /// Allows the handler to provide an array of supplementary views that will
    /// be displayed as onscreen controls
    ///
    /// - Returns: array of supplementary views or nil if those views are not required
    func supplementaryOnScreenViews() -> [UIView]?
}

internal extension ARHandler {
    func tappedWithHitTestResults(_ results: [SCNHitTestResult]) {}
    func longPressedStartedWithHitTestResults(_ results: [SCNHitTestResult]) {}
    func longPressedChangedWithHitTestResults(_ results: [SCNHitTestResult], onScreenTranslation traslation: CGPoint) {}
    func longPressedFinished() {}
    func supplementaryOnScreenViews() -> [UIView]? { return nil }
}

