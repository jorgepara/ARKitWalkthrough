//
//  MainViewController+Extensions.swift
//  ARKitWalkthrough
//
//  Created by Para Molina, Jorge (Cognizant) on 4/22/19.
//  Copyright © 2019 Para Molina, Jorge (Cognizant). All rights reserved.
//

import Foundation
import UIKit

internal extension MainViewController {

    enum State: String, CaseIterable {
        case Debug = "1"
        case Tracking = "2"
        case CoordinateSpaces = "3"
    }

    static let InitialState: State = .Debug

    func makeViewControllerFor(state: State) -> ARViewController? {
        switch state {
        case .Debug:
            return DebugViewController(viewModel: DebugViewModel())
        case .Tracking:
            return TrackingViewController(viewModel: TrackingViewModel())
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
