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

/// Handler for demostrating the different coordinate spaces of different objects
/// and how transformations in a parent node affect the child nodes
internal class CoordinateSpacesHandler: ARHandler {

    lazy var configuration: ARConfiguration = {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        return configuration
    }()

    var sessionOptions: ARSession.RunOptions = [.removeExistingAnchors]
    var debugOptions: ARSCNDebugOptions = []
    var sceneUpdateQueue: DispatchQueue? = nil


    private var parentNode: SCNNode?
    private var childNode: SCNNode?
    private weak var parentButton: OnScreenButton?
    private weak var childButton: OnScreenButton?
    private var playgroundFound = false

    func anchorWasAdded(withAnchor anchor: ARAnchor, node: SCNNode) {
        guard !playgroundFound, anchor is ARPlaneAnchor, let scene = SCNScene(named: "scene.scnassets/scene.scn") else { return }
        playgroundFound = true
        sceneUpdateQueue?.async {
            scene.rootNode.childNodes.forEach { [weak self] in
                node.addChildNode($0)
                guard let strongSelf = self else { return }
                // Add visual axis to the objects for a better understanding of the transformations
                strongSelf.addAxesInHierarchy(forNode: $0)
                // The box object is identified as the parent node and its first child is the child node
                // for later transformations
                if $0.name == "box" {
                    strongSelf.parentNode = $0
                    strongSelf.childNode = $0.childNodes.first
                }
            }
        }
    }

    func anchorWasUpdated(withAnchor anchor: ARAnchor, node: SCNNode) {}


    /// Returns 4 buttons. 2 of them selecting which objects will be affected by the transformation
    /// and 2 objects for translation and rotation.
    func supplementaryOnScreenViews() -> [UIView]? {
        var views = [UIView]()

        let parentButton = OnScreenButton(withIcon: "P")
        parentButton.addTarget(self, action: #selector(switchObject(sender:)), for: .touchUpInside)
        views.append(parentButton)
        self.parentButton = parentButton

        let childButton = OnScreenButton(withIcon: "C")
        childButton.addTarget(self, action: #selector(switchObject(sender:)), for: .touchUpInside)
        views.append(childButton)
        self.childButton = childButton

        let rotateButton = OnScreenButton(withIcon: "R")
        rotateButton.addTarget(self, action: #selector(rotateSelected(sender:)), for: .touchUpInside)
        views.append(rotateButton)


        let translateButton = OnScreenButton(withIcon: "T")
        translateButton.addTarget(self, action: #selector(translateSelected(sender:)), for: .touchUpInside)
        views.append(translateButton)

        return views
    }

    @objc private func switchObject(sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }

    @objc private func rotateSelected(sender: UIButton) {
        var selected = [SCNNode?]()
        if let parentButton = parentButton, parentButton.isSelected { selected.append(parentNode) }
        if let childButton = childButton, childButton.isSelected { selected.append(childNode) }
        SCNTransaction.animationDuration = 1
        selected.forEach {
            guard let selected = $0 else { return }
            selected.simdLocalRotate(by: simd_quaternion(45, simd_make_float3(0, 0, 1)))
        }
    }

    @objc private func translateSelected(sender: UIButton) {
        var selected = [SCNNode?]()
        if let parentButton = parentButton, parentButton.isSelected { selected.append(parentNode) }
        if let childButton = childButton, childButton.isSelected { selected.append(childNode) }
        SCNTransaction.animationDuration = 1
        selected.forEach { $0?.localTranslate(by: SCNVector3(0.01, 0, 0)) }
    }

    private func addAxesInHierarchy(forNode node: SCNNode) {
        node.childNodes.forEach { addAxesInHierarchy(forNode: $0) }
        // Only nodes with a geometry will have axis (therefore ignoring lights cameras or any other objects).
        if node.geometry != nil { node.addChildNode(makeAxes()) }
    }

    /// Draw origin and x, y and z axis with the color convention of red, green and blue
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
