//
//  MainViewController.swift
//  ARKitWalkthrough
//
//  Created by Para Molina, Jorge (Cognizant) on 4/23/19.
//  Copyright © 2019 Para Molina, Jorge (Cognizant). All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    private let coordinator = Coordinator()

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let viewController = coordinator.viewControllerForCurrentState() else { return }

        self.addChild(viewController)
        self.view.addSubview(viewController.view)
        viewController.didMove(toParent: self)
    }
}
