//
//  InteractionsHandler.swift
//  ARKitWalkthrough
//
//  Copyright © 2019-present Para Molina, Jorge. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation
import SceneKit

/// Handler for showing basic interaction with a virtual object and how we can give visual feedback to the user
internal class InteractionsHandler: ObjectOnPlaneHandler, ARGestureDelegate {

    private static let verticalGapPressed: Float =  0.01
    private static let motionAnimationDuration = 0.5

    private var cupInMotion = false

    func longPressedStartedWithHitTestResults(_ results: [SCNHitTestResult]) {
        if !cupInMotion && !results.map({ return $0.node }).filter({ $0.name?.starts(with: "Circle") ?? false }).isEmpty {
            cupInMotion = true
            SCNTransaction.animationDuration = InteractionsHandler.motionAnimationDuration
            cupNode.opacity = 0.5
            cupNode.localTranslate(by: SCNVector3(0, InteractionsHandler.verticalGapPressed, 0))
        }
    }
    func longPressedChangedWithHitTestResults(_ results: [SCNHitTestResult], onScreenTranslation traslation: CGPoint) {
        if cupInMotion, let playgroundResult = results.filter({ $0.node == playgroundNode }).first {
            let hitIntersection = playgroundResult.localCoordinates
            SCNTransaction.animationDuration = InteractionsHandler.motionAnimationDuration
            cupNode.position = SCNVector3(x: hitIntersection.x, y: InteractionsHandler.verticalGapPressed, z: -hitIntersection.y)
        }
    }
    func longPressedFinished() {
        if cupInMotion {
            cupInMotion = false
            cupNode.opacity = 1
            cupNode.localTranslate(by: SCNVector3(0, -InteractionsHandler.verticalGapPressed, 0))
        }
    }


}
