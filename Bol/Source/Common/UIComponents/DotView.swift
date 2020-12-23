//
//  DotView.swift
//  Bol
//
//  Created by Abdelrahman Ali on 20/12/2020.
//

import UIKit

// MARK: Representing the dots used in `PageControlView`
final class DotView: UIView {

    override func tintColorDidChange() {

        // Only do this when focused, otherwise
        // The colour will change when scrolling
        if isFocused {
            backgroundColor = tintColor
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updateCornerRadius()
    }

    override var frame: CGRect {
        didSet {
            updateCornerRadius()
        }
    }

    private func updateCornerRadius() {
        layer.cornerRadius = min(bounds.width, bounds.height) / 2
    }
}
