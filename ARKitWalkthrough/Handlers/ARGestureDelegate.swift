//
//  ARGestureDelegate.swift
//  ARKitWalkthrough
//
//  Created by Para Molina, Jorge (Cognizant) on 5/24/19.
//  Copyright © 2019 Para Molina, Jorge (Cognizant). All rights reserved.
//

import Foundation
import SceneKit

/// Protocol for the AR gesture delegates that will define
/// the behavior for event management
internal protocol ARGestureDelegate {
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
}

internal extension ARGestureDelegate {
    func tappedWithHitTestResults(_ results: [SCNHitTestResult]) {}
    func longPressedStartedWithHitTestResults(_ results: [SCNHitTestResult]) {}
    func longPressedChangedWithHitTestResults(_ results: [SCNHitTestResult], onScreenTranslation traslation: CGPoint) {}
    func longPressedFinished() {}
}
