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
internal class ARViewController: UIViewController {

    private lazy var scene: ARSCNView = {
        let scene = ARSCNView(frame: .zero)
        scene.translatesAutoresizingMaskIntoConstraints = false
        scene.debugOptions = handler?.debugOptions ?? []
        scene.delegate = self
        return scene
    }()

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

}

internal extension MainViewController {

    enum State: String, CaseIterable {
        case Debug = "1"
        case Tracking = "2"
        case CoordinateSpaces = "3"
    }

    static let InitialState: State = .Debug

    func makeHandlerFor(state: State) -> ARHandler? {
        switch state {
        case .Debug:
            return DebugHandler()
        case .Tracking:
            return TrackingHandler()
        default:
            return nil
        }
    }

}

internal extension MainViewController {
    struct Constants {
        static let buttonVerticalMargin: CGFloat = 40
        static let buttonLeftMargin: CGFloat = 10
        static let buttonSize: CGFloat = 45
        static let buttonSpacing: CGFloat = 20
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
