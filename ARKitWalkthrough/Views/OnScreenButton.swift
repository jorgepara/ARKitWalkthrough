//
//  OnScreenButton.swift
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

// A button for being placed on the screen over an AR scene
class OnScreenButton: UIButton {

    private static let buttonSize: CGFloat = 44
    private static let imageInsets: CGFloat = 5

    init(withIcon icon: String) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        imageEdgeInsets = UIEdgeInsets(top: OnScreenButton.imageInsets, left: OnScreenButton.imageInsets, bottom: OnScreenButton.imageInsets, right: OnScreenButton.imageInsets)
        if let imageSelected = UIImage(named: icon + "Selected"), let imageDeselected = UIImage(named: icon + "Deselected") {
            setImage(imageSelected, for: [.selected, .highlighted])
            setImage(imageSelected, for: .selected)
            setImage(imageSelected, for: .highlighted)
            setImage(imageDeselected, for: [])
        } else {
            setTitle(icon, for: .normal)
            setTitleColor(UIColor.supplementaryButtonTextSelected, for: .selected)
            setTitleColor(UIColor.supplementaryButtonDeselected, for: .normal)
        }
        backgroundColor = UIColor.supplementaryButtonBackground
        clipsToBounds = true
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: OnScreenButton.buttonSize),
            heightAnchor.constraint(equalToConstant: OnScreenButton.buttonSize)
            ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
