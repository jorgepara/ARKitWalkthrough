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

    private lazy var stackStates: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .center
        stackView.spacing = Constants.buttonSpacing
        stackView.distribution = UIStackView.Distribution.equalCentering
        stackView.axis = .vertical
        return stackView
    }()

    private var stateIndexes: [Coordinator.State:Int] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(stackStates)
        NSLayoutConstraint.activate([
            stackStates.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.buttonLeftMargin),
            stackStates.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.buttonVerticalMargin),
            stackStates.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -Constants.buttonVerticalMargin),
            stackStates.widthAnchor.constraint(equalToConstant: Constants.buttonSize)
            ])

        Coordinator.State.allCases.enumerated().forEach { addButtonForState($1, withIndex: $0) }

        updateState(Coordinator.InitialState)
    }

    private func addButtonForState( _ state: Coordinator.State, withIndex index: Int) {
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

    @objc private func tapState(sender: UIButton!) {
        if let state = stateIndexes.keys.filter ( { stateIndexes[$0] == sender.tag } ).first {
            updateState(state)
        }
    }

    private func updateState(_ state: Coordinator.State) {

        stackStates.arrangedSubviews.filter {$0 is UIButton}.forEach {
            if stateIndexes[state] == $0.tag {
                $0.backgroundColor = UIColor.selectedState
            } else {
                $0.backgroundColor = UIColor.deselectedState
            }
        }

        guard let viewController = coordinator.viewControllerFor(state: state) else { return }

        children.forEach {
            $0.removeFromParent()
            $0.view.removeFromSuperview()
        }

        addChild(viewController)
        view.addSubview(viewController.view)
        viewController.didMove(toParent: self)

        view.bringSubviewToFront(stackStates)
    }
}

private extension MainViewController {
    struct Constants {
        static let buttonVerticalMargin: CGFloat = 40
        static let buttonLeftMargin: CGFloat = 10
        static let buttonSize: CGFloat = 45
        static let buttonSpacing: CGFloat = 20
    }
}

private extension UIColor {

    static let deselectedState = UIColor.darkGray.withAlphaComponent(0.4)
    static let selectedState = UIColor.init(red: 0.098039215686275, green: 0.23921568627451, blue: 0.556862745098039, alpha: 0.7)
}
