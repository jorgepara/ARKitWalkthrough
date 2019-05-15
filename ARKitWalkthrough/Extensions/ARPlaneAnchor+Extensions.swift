//
//  ARPlaneAnchor+Extensions.swift
//  ARKitWalkthrough
//
//  Created by Para Molina, Jorge (Cognizant) on 5/15/19.
//  Copyright © 2019 Para Molina, Jorge (Cognizant). All rights reserved.
//

import Foundation
import ARKit

extension ARPlaneAnchor {


    /// Creates a node that represents the subjacent plane for this anchor,
    /// with the same position and size
    /// and a traslucent color
    ///
    /// - Returns: <#return value description#>
    func nodeRepresentation() -> SCNNode {
        let width = CGFloat(self.extent.x)
        let height = CGFloat(self.extent.z)
        let plane = SCNPlane(width: width, height: height)
        plane.materials.first?.diffuse.contents = UIColor.lightGray.withAlphaComponent(0.2)

        let planeNode = SCNNode(geometry: plane)
        let x = CGFloat(self.center.x)
        let y = CGFloat(self.center.y)
        let z = CGFloat(self.center.z)
        planeNode.position = SCNVector3(x,y,z)
        planeNode.eulerAngles.x = -.pi / 2

        return planeNode
    }
}
