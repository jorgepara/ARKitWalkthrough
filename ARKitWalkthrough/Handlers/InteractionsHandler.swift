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

    override func tappedWithHitTestResults(_ results: [SCNHitTestResult]) {
        print(results)
    }

}
