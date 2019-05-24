//
//  MainViewController.swift
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

import UIKit

// Main view controller of the app. It hosts the view controller with the AR scene
// together with the UIKit views used to browse the content of walkthrough
class MainViewController: UIViewController {

    private lazy var stackStates: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.spacing = Constants.buttonSpacing
        stackView.distribution = UIStackView.Distribution.equalCentering
        stackView.axis = .vertical
        return stackView
    }()

    private lazy var stackSupplementaryViews: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.spacing = Constants.supplementaryViewSpacing
        stackView.distribution = UIStackView.Distribution.equalCentering
        stackView.axis = .horizontal
        return stackView
    }()

    private var stateIndexes: [State:Int] = [:]

    private var arViewController: ARViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(stackStates)
        NSLayoutConstraint.activate([
            stackStates.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: Constants.buttonLeftMargin),
            stackStates.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.buttonVerticalMargin),
            stackStates.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Constants.buttonVerticalMargin),
            stackStates.widthAnchor.constraint(equalToConstant: Constants.buttonSize)
            ])

        State.allCases.enumerated().forEach { addButtonForState($1, withIndex: $0) }

        view.addSubview(stackSupplementaryViews)
        NSLayoutConstraint.activate([
            stackSupplementaryViews.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.supplementaryViewLateralMargin),
            stackSupplementaryViews.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.supplementaryViewLateralMargin),
            stackSupplementaryViews.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            stackSupplementaryViews.heightAnchor.constraint(equalToConstant: Constants.supplementaryViewHeight)
            ])

        arViewController = ARViewController()
        addChild(arViewController)
        view.addSubview(arViewController.view)
        arViewController.didMove(toParent: self)

        updateState(MainViewController.InitialState)
    }


    /// Add to the state stack view a button for the given state, in the order
    /// corresponding to the given index
    ///
    /// - Parameters:
    ///   - state: the state represented by the button
    ///   - index: the index of the button within the list of states
    private func addButtonForState( _ state: State, withIndex index: Int) {
        let button = UIButton(frame: .zero)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(state.rawValue, for: .normal)
        button.backgroundColor = UIColor.navigationButtonbackgroundDeselected
        button.layer.cornerRadius = Constants.buttonSize/2
        button.clipsToBounds = true
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: Constants.buttonSize),
            button.heightAnchor.constraint(equalToConstant: Constants.buttonSize)
            ])

        button.addTarget(self, action: #selector(tapState(sender:)), for: .touchUpInside)

        button.tag = index
        stateIndexes[state] = index

        stackStates.addArrangedSubview(button)
    }

    /// Tapping in a button representing a state will switch to that state
    @objc private func tapState(sender: UIButton!) {
        if let state = stateIndexes.keys.filter ( { stateIndexes[$0] == sender.tag } ).first {
            updateState(state)
        }
    }

    /// When updating the state, the background color of the buttons representing the states
    /// is updated to highlight only the new state, and a new pair of delegates is created and injected
    /// in the AR view controller
    private func updateState(_ state: State) {
        stackStates.arrangedSubviews.filter {$0 is UIButton}.forEach {
            if stateIndexes[state] == $0.tag {
                $0.backgroundColor = UIColor.navigationButtonBackgroundSelected
            } else {
                $0.backgroundColor = UIColor.navigationButtonbackgroundDeselected
            }
        }

        let delegates = makeDelegatesFor(state: state)
        arViewController.sceneDelegate = delegates.sceneDelegate
        arViewController.gestureDelegate = delegates.gestureDelegate

        stackSupplementaryViews.removeAllArrangedSubviews()
        // TODO: this is a form of feature envy.
        arViewController.sceneDelegate?.supplementaryOnScreenViews()?.forEach { stackSupplementaryViews.addArrangedSubview($0) }

        view.bringSubviewToFront(stackStates)
        view.bringSubviewToFront(stackSupplementaryViews)
    }
}

internal extension MainViewController {

    // These are the possible states of the AR walkthrough
    enum State: String, CaseIterable {
        case Debug = "1"
        case Tracking = "2"
        case CoordinateSpaces = "3"
        case Matrices = "4"
        case Interactions = "5"
    }

    static let InitialState: State = .Debug

    func makeDelegatesFor(state: State) -> (sceneDelegate: ARSceneDelegate?, gestureDelegate: ARGestureDelegate?) {
        switch state {
        case .Debug:
            return (DebugHandler(), nil)
        case .Tracking:
            return (TrackingHandler(), nil)
        case .CoordinateSpaces:
            return (CoordinateSpacesHandler(), nil)
        case .Matrices:
            return (MatricesHandler(), nil)
        case .Interactions:
            let handler = InteractionsHandler()
            return (handler, handler)
        }
    }

}

internal extension MainViewController {
    struct Constants {
        static let buttonVerticalMargin: CGFloat = 20
        static let buttonLeftMargin: CGFloat = 10
        static let buttonSize: CGFloat = 50
        static let buttonSpacing: CGFloat = 20
        static let supplementaryViewSpacing: CGFloat = 15
        static let supplementaryViewLateralMargin: CGFloat = 220
        static let supplementaryViewHeight: CGFloat = 60
    }
}
