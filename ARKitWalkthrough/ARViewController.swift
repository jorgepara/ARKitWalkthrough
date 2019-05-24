//
//  ARViewController.swift
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
import UIKit
import ARKit

/// View controller for AR scene, it will manage the basics of the lifecycle of the scene
/// and will rely on delegates for the configuration and event management
internal class ARViewController: UIViewController {

    private var lastTraslationPoint: CGPoint?

    private lazy var scene: ARSCNView = {
        let scene = ARSCNView(frame: .zero)
        scene.translatesAutoresizingMaskIntoConstraints = false
        scene.debugOptions = sceneDelegate?.debugOptions ?? []
        scene.delegate = self
        return scene
    }()

    // This dispatch queue can be used by the delegates for updating the scene
    private let sceneUpdateQueue = DispatchQueue(label: "SerialSceneKitQueue")

    var sceneDelegate: ARSceneDelegate? {
        didSet {
            if var sceneDelegate = self.sceneDelegate {
                sceneDelegate.sceneUpdateQueue = sceneUpdateQueue
                scene.debugOptions = sceneDelegate.debugOptions
                scene.session.run(sceneDelegate.configuration, options: sceneDelegate.sessionOptions)
            }
        }
    }

    var gestureDelegate: ARGestureDelegate?

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

        scene.autoenablesDefaultLighting = true
        scene.automaticallyUpdatesLighting = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let sceneDelegate = self.sceneDelegate {
            scene.session.run(sceneDelegate.configuration, options: sceneDelegate.sessionOptions)
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
            gestureDelegate?.tappedWithHitTestResults(hitTestResults)
        }
    }
    @objc func longPressed(recognizer: UILongPressGestureRecognizer) {
        let location = recognizer.location(in: scene)
        let hitTestResults = scene.hitTest(location)
        if recognizer.state == .began {
            if !hitTestResults.isEmpty {
                lastTraslationPoint = location
                gestureDelegate?.longPressedStartedWithHitTestResults(hitTestResults)
            }
        } else if recognizer.state == .changed {
            let traslation = CGPoint(x: location.x - (lastTraslationPoint?.x ?? 0), y: location.y - (lastTraslationPoint?.y ?? 0))
            lastTraslationPoint = location
            gestureDelegate?.longPressedChangedWithHitTestResults(hitTestResults, onScreenTranslation: traslation)
        } else if recognizer.state == .ended {
            gestureDelegate?.longPressedFinished()
        }
    }
}

extension ARViewController: ARSCNViewDelegate {

    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        sceneDelegate?.anchorWasAdded(withAnchor: anchor, node: node)
    }

    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        sceneDelegate?.anchorWasUpdated(withAnchor: anchor, node: node)
    }
}
