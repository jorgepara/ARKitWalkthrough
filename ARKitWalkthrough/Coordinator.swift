//
//  Coordinator.swift
//  ARKitWalkthrough
//
//  Created by Para Molina, Jorge (Cognizant) on 4/22/19.
//  Copyright © 2019 Para Molina, Jorge (Cognizant). All rights reserved.
//

import Foundation

enum MyTest {

}

internal class Coordinator {

    enum State: String, CaseIterable {
        case Debug = "1"
        case Tracking = "2"
        case CoordinateSpaces = "3"
    }

    static let InitialState = State.allCases.first ?? .Debug

    func viewControllerFor(state: State) -> ARViewController? {
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
