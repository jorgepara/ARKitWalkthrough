//
//  MainViewController.swift
//  ARKitWalkthrough
//
//  Created by Para Molina, Jorge (Cognizant) on 4/23/19.
//  Copyright © 2019 Para Molina, Jorge (Cognizant). All rights reserved.
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
            stackStates.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.buttonLeftMargin),
            stackStates.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.buttonVerticalMargin),
            stackStates.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Constants.buttonVerticalMargin),
            stackStates.widthAnchor.constraint(equalToConstant: Constants.buttonSize)
            ])

        State.allCases.enumerated().forEach { addButtonForState($1, withIndex: $0) }

        view.addSubview(stackSupplementaryViews)
        NSLayoutConstraint.activate([
            stackSupplementaryViews.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.supplementaryViewLateralMargin),
            stackSupplementaryViews.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -Constants.supplementaryViewLateralMargin),
            stackSupplementaryViews.bottomAnchor.constraint(equalTo: view.bottomAnchor),
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
        button.backgroundColor = UIColor.deselectedState
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
    /// is updated to highlight only the new state, and a new handler is created and injected
    /// in the AR view controller
    private func updateState(_ state: State) {
        stackStates.arrangedSubviews.filter {$0 is UIButton}.forEach {
            if stateIndexes[state] == $0.tag {
                $0.backgroundColor = UIColor.selectedState
            } else {
                $0.backgroundColor = UIColor.deselectedState
            }
        }

        arViewController.handler = makeHandlerFor(state: state)

        stackSupplementaryViews.removeAllArrangedSubviews()
        // TODO: this is a form of feature envy.
        arViewController.handler?.supplementaryOnScreenViews()?.forEach { stackSupplementaryViews.addArrangedSubview($0) }

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
    }

    static let InitialState: State = .Debug

    func makeHandlerFor(state: State) -> ARHandler? {
        switch state {
        case .Debug:
            return DebugHandler()
        case .Tracking:
            return TrackingHandler()
        case .CoordinateSpaces:
            return CoordinateSpacesHandler()
        case .Matrices:
            return MatricesHandler()
        }
    }

}

internal extension MainViewController {
    struct Constants {
        static let buttonVerticalMargin: CGFloat = 40
        static let buttonLeftMargin: CGFloat = 10
        static let buttonSize: CGFloat = 50
        static let buttonSpacing: CGFloat = 20
        static let supplementaryViewSpacing: CGFloat = 15
        static let supplementaryViewLateralMargin: CGFloat = 220
        static let supplementaryViewHeight: CGFloat = 60
    }
}
