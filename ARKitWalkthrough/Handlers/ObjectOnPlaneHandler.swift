//
//  ObjectOnPlaneHandler.swift
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
import ARKit

/// Base handler for find a plane and adding a virtual object, on top of that
/// other concepts will be demostrated
internal class ObjectOnPlaneHandler: ARSceneDelegate {

    lazy var configuration: ARConfiguration = {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        return configuration
    }()

    lazy var cupNode: SCNNode = {
        let cupNode = SCNNode(geometry: nil)
        guard let scene = SCNScene(named: "CupSceneAssets.scnassets/glass.scn") else { return cupNode }
        sceneUpdateQueue?.async {
            scene.rootNode.childNodes.forEach { [weak self] in
                cupNode.addChildNode($0)
            }
        }
        return cupNode
    }()

    weak var playgroundNode: SCNNode?

    var sessionOptions: ARSession.RunOptions = [.removeExistingAnchors]
    var debugOptions: ARSCNDebugOptions = []
    var sceneUpdateQueue: DispatchQueue? = nil

    private static let mininumLenght: CGFloat = 0.3

    private var playgroundFound =  false

    func anchorWasAdded(withAnchor anchor: ARAnchor, node: SCNNode) {}

    func anchorWasUpdated(withAnchor anchor: ARAnchor, node: SCNNode) {
        guard !playgroundFound else { return }

        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }

        let width = CGFloat(planeAnchor.extent.x)
        let height = CGFloat(planeAnchor.extent.z)

        guard width >= ObjectOnPlaneHandler.mininumLenght, height >= ObjectOnPlaneHandler.mininumLenght  else { return }

        playgroundFound = true

        let planeNode = planeAnchor.nodeRepresentation(withAlpha: 0)
        playgroundNode = planeNode

        sceneUpdateQueue?.async { [weak self] in
            guard let self = self else { return }
            node.addChildNode(planeNode)
            node.addChildNode(self.cupNode)
        }
    }

    func supplementaryOnScreenViews() -> [UIView]? { return nil }
}
