//
//  Coordinator.swift
//  ARKitWalkthrough
//
//  Created by Para Molina, Jorge (Cognizant) on 4/22/19.
//  Copyright © 2019 Para Molina, Jorge (Cognizant). All rights reserved.
//

import Foundation

internal class Coordinator {

    static let InitialState = State.allCases.first ?? .Debug

    private var currentState = InitialState

    func next() -> Bool {
        if let next = State.allCases.after(currentState) {
            currentState = next
            return true
        }
        return false
    }

    func previous() -> Bool {
        if let previous = State.allCases.before(currentState) {
            currentState = previous
            return true
        }
        return false
    }

    func viewControllerForCurrentState() -> ARViewController? {
        switch currentState {
        case .Debug:
            return DebugViewController(viewModel: DebugViewModel())
        default:
            return nil
        }
    }

}

// From https://stackoverflow.com/questions/45340536/get-next-or-previous-item-to-an-object-in-a-swift-collection-or-array
private extension BidirectionalCollection where Iterator.Element: Equatable {
    typealias Element = Self.Iterator.Element

    func after(_ item: Element, loop: Bool = false) -> Element? {
        if let itemIndex = self.firstIndex(of: item) {
            let lastItem: Bool = (index(after:itemIndex) == endIndex)
            if loop && lastItem {
                return self.first
            } else if lastItem {
                return nil
            } else {
                return self[index(after:itemIndex)]
            }
        }
        return nil
    }

    func before(_ item: Element, loop: Bool = false) -> Element? {
        if let itemIndex = self.firstIndex(of: item) {
            let firstItem: Bool = (itemIndex == startIndex)
            if loop && firstItem {
                return self.last
            } else if firstItem {
                return nil
            } else {
                return self[index(before:itemIndex)]
            }
        }
        return nil
    }
}

