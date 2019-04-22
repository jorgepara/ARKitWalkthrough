//
//  ViewController.swift
//  ARKitWalkthrough
//
//  Created by Para Molina, Jorge (Cognizant) on 3/22/19.
//  Copyright © 2019 Para Molina, Jorge (Cognizant). All rights reserved.
//

import UIKit
import ARKit


/// Main view controller, it will host the AR scene
class ViewController: UIViewController {

    @IBOutlet weak var scene: ARSCNView!

    private let sceneUpdateQueue = DispatchQueue(label: "SerialSceneKitQueue")
    private let viewModel = ViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        viewModel.updateSceneDebugOptions = { [weak self] debugOptions in
            guard let strongSelf = self else { return }
            strongSelf.sceneUpdateQueue.async { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.scene.debugOptions = debugOptions
            }
        }
        viewModel.updateSceneConfiguration = { [weak self] configuration in
            guard let strongSelf = self else { return }
            strongSelf.scene.session.run(configuration, options: strongSelf.viewModel.sessionOptions)
        }
        scene.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        scene.session.run(viewModel.configuration, options: viewModel.sessionOptions)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        scene.session.pause()
    }

    @IBAction func toggleWorldOrigin(_ sender: UISwitch) {
        viewModel.showWorldOrigin(sender.isOn)
    }

    @IBAction func toogleFeaturePoints(_ sender: UISwitch) {
        viewModel.showFeaturePoints(sender.isOn)
    }

    @IBAction func tooglePlaneDetection(_ sender: UISwitch) {
        viewModel.showPlanes(sender.isOn)
    }
}

extension ViewController: ARSCNViewDelegate {

    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        viewModel.anchorWasAdded(withAnchor: anchor, node: node)
    }

    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        viewModel.anchorWasUpdated(withAnchor: anchor, node: node)
    }
}
