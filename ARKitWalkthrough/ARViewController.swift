//
//  ARViewController.swift
//  ARKitWalkthrough
//
//  Created by Para Molina, Jorge (Cognizant) on 4/23/19.
//  Copyright © 2019 Para Molina, Jorge (Cognizant). All rights reserved.
//

import Foundation
import UIKit
import ARKit

/// View controller for AR scene, it will manage the basics of the lifecycle of the scene
/// and will rely on a handler for the configuration and event management
internal class ARViewController: UIViewController {

    private var lastTraslationPoint: CGPoint?

    private lazy var scene: ARSCNView = {
        let scene = ARSCNView(frame: .zero)
        scene.translatesAutoresizingMaskIntoConstraints = false
        scene.debugOptions = handler?.debugOptions ?? []
        scene.delegate = self
        return scene
    }()

    // This dispatch queue can be used by the handlers for updating the scene
    private let sceneUpdateQueue = DispatchQueue(label: "SerialSceneKitQueue")

    var handler: ARHandler? {
        didSet {
            if var handler = self.handler {
                handler.sceneUpdateQueue = sceneUpdateQueue
                scene.debugOptions = handler.debugOptions
                scene.session.run(handler.configuration, options: handler.sessionOptions)
            }
        }
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scene)
        NSLayoutConstraint.activate([
            scene.heightAnchor.constraint(equalTo: view.heightAnchor),
            scene.widthAnchor.constraint(equalTo: view.widthAnchor),
            scene.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scene.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped(recognizer:)))
        scene.addGestureRecognizer(tapGestureRecognizer)
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressed(recognizer:)))
        scene.addGestureRecognizer(longPressRecognizer)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let handler = self.handler {
            scene.session.run(handler.configuration, options: handler.sessionOptions)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        scene.session.pause()
    }

    @objc func tapped(recognizer: UIGestureRecognizer) {
        let location = recognizer.location(in: scene)
        let hitTestResults = scene.hitTest(location)
        if !hitTestResults.isEmpty {
            handler?.tappedWithHitTestResults(hitTestResults)
        }
    }
    @objc func longPressed(recognizer: UILongPressGestureRecognizer) {
        let location = recognizer.location(in: scene)
        let hitTestResults = scene.hitTest(location)
        if recognizer.state == .began {
            if !hitTestResults.isEmpty {
                lastTraslationPoint = location
                handler?.longPressedStartedWithHitTestResults(hitTestResults)
            }
        } else if recognizer.state == .changed {
            let traslation = CGPoint(x: location.x - (lastTraslationPoint?.x ?? 0), y: location.y - (lastTraslationPoint?.y ?? 0))
            lastTraslationPoint = location
            handler?.longPressedChangedWithHitTestResults(hitTestResults, onScreenTranslation: traslation)
        } else if recognizer.state == .ended {
            handler?.longPressedFinished()
        }
    }
}

extension ARViewController: ARSCNViewDelegate {

    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        handler?.anchorWasAdded(withAnchor: anchor, node: node)
    }

    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        handler?.anchorWasUpdated(withAnchor: anchor, node: node)
    }
}
