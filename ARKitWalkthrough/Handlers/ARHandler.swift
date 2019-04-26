//
//  ARHandler.swift
//  ARKitWalkthrough
//
//  Created by Para Molina, Jorge (Cognizant) on 4/23/19.
//  Copyright © 2019 Para Molina, Jorge (Cognizant). All rights reserved.
//

import Foundation
import ARKit

internal protocol ARHandler {

    var configuration: ARConfiguration { get }
    var sessionOptions: ARSession.RunOptions { get }
    var debugOptions: ARSCNDebugOptions { get }
    var sceneUpdateQueue: DispatchQueue? { get set }


    func anchorWasAdded(withAnchor anchor: ARAnchor, node: SCNNode)
    func anchorWasUpdated(withAnchor anchor: ARAnchor, node: SCNNode)

}
