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

/// Base view controller for AR, it will manage the basics of the lifecycle of the scene
internal class ARViewController: UIViewController {

    private lazy var scene: ARSCNView = {
        let scene = ARSCNView(frame: .zero)
        scene.translatesAutoresizingMaskIntoConstraints = false
        scene.debugOptions = viewModel.debugOptions
        scene.delegate = self
        return scene
    }()

    private let sceneUpdateQueue = DispatchQueue(label: "SerialSceneKitQueue")

    var viewModel: ARViewModel

    // MARK: - Init
    
    init(viewModel: ARViewModel) {
        self.viewModel = viewModel
        self.viewModel.sceneUpdateQueue = sceneUpdateQueue
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(scene)
        scene.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        scene.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scene.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scene.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        scene.session.run(viewModel.configuration, options: viewModel.sessionOptions)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        scene.session.pause()
    }

}

extension ARViewController: ARSCNViewDelegate {

    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        viewModel.anchorWasAdded(withAnchor: anchor, node: node)
    }

    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        viewModel.anchorWasUpdated(withAnchor: anchor, node: node)
    }
}
