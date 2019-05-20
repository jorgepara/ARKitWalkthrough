//
//  InteractionsHandler.swift
//  ARKitWalkthrough
//
//  Created by Para Molina, Jorge (Cognizant) on 5/16/19.
//  Copyright © 2019 Para Molina, Jorge (Cognizant). All rights reserved.
//

import Foundation
import SceneKit

/// Handler for showing basic interactiosn with a virtual object and how placeholders
/// and hints can support the user 
internal class InteractionsHandler: ObjectOnPlaneHandler {

    private let verticalGapPressed: Float =  0.01
    private var cupInMotion = false

    override func longPressedStartedWithHitTestResults(_ results: [SCNHitTestResult]) {
        if !cupInMotion && !results.map({ return $0.node }).filter({ $0.name?.starts(with: "Circle") ?? false }).isEmpty {
            cupInMotion = true
            SCNTransaction.animationDuration = 0.5
            cupNode.opacity = 0.5
            cupNode.localTranslate(by: SCNVector3(0, verticalGapPressed, 0))
        }
    }
    override func longPressedChangedWithHitTestResults(_ results: [SCNHitTestResult], onScreenTranslation traslation: CGPoint) {
        if cupInMotion, let playgroundResult = results.filter({ $0.node == playgroundNode }).first {
            let hitIntersection = playgroundResult.localCoordinates
            SCNTransaction.animationDuration = 0.5
            cupNode.position = SCNVector3(x: hitIntersection.x, y: verticalGapPressed, z: -hitIntersection.y)
        }
    }
    override func longPressedFinished() {
        if cupInMotion {
            cupInMotion = false
            cupNode.opacity = 1
            cupNode.localTranslate(by: SCNVector3(0, -verticalGapPressed, 0))
        }
    }


}
