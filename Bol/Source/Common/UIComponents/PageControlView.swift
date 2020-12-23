//
//  PageControlView.swift
//  Bol
//
//  Created by Abdelrahman Ali on 20/12/2020.
//

import UIKit

final class PageControlView: UIView {

    /// Set this varieble to create the dots for pages
    var pages: Int = 0 {
        didSet {
            /// Create dot for each page
            dots = (0 ..< pages).map { _ in
                DotView(frame: CGRect(origin: .zero,
                                           size: CGSize(width: dotSize, height: dotSize)))
            }
            setNeedsDisplay()
            invalidateIntrinsicContentSize()
        }
    }

    var currentPage: Int = 0 {
        didSet {
            if (0 ..< centerDots).contains(currentPage - pageOffset) {
                centerOffset = currentPage - pageOffset
            } else {
                pageOffset = currentPage - centerOffset
            }
            updateColors()
        }
    }

    /// Unselected Dots color
    var pageColor = UIColor(white: 1, alpha: 0.5) {
        didSet {
            setNeedsDisplay()
        }
    }

    /// Highlighted Dot color
    var currentPageColor = UIColor.mainColor {
        didSet {
            setNeedsDisplay()
        }
    }

    /// Maximum number of Dots to show
    var maxDots = 10 {
        didSet {
            if maxDots % 2 == 1 {
                maxDots += 1
                debugPrint("maxPages has to be an even number")
            }
            invalidateIntrinsicContentSize()
            updatePositions()
        }
    }

    var centerDots = 8 {
        didSet {
            if centerDots % 2 == 1 {
                centerDots += 1
                debugPrint("centerDots has to be an even number")
            }
            invalidateIntrinsicContentSize()
            updatePositions()
        }
    }

    private let dotSize: CGFloat = 6
    private let spacing: CGFloat = 4
    private var centerOffset = 0

    func prepareForReuse() {
        pages = 0
        currentPage = 0
        centerOffset = 0
        pageOffset = 0
        dots.removeAll()
    }

    private var pageOffset = 0 {
        didSet {
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                UIView.animate(withDuration: 0.2, animations: self.updatePositions)
            }
        }
    }

    private var dots: [UIView] = [] {
        didSet {
            oldValue.forEach { $0.removeFromSuperview() }
            dots.forEach(addSubview)
            updateColors()
            updatePositions()
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        isOpaque = false
    }

    override var intrinsicContentSize: CGSize {
        let pages = min(maxDots, self.pages)
        let width = CGFloat(pages) * dotSize + CGFloat(pages - 1) * spacing
        let height = dotSize
        return CGSize(width: width, height: height)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        updatePositions()
    }

    private func updateColors() {

        dots.enumerated().forEach { page, dot in
            dot.backgroundColor = page == currentPage ? currentPageColor : pageColor
        }
    }

    private func updatePositions() {
        
        let sidePages = (maxDots - centerDots) / 2
        let horizontalOffset = CGFloat(-pageOffset + sidePages) * (dotSize + spacing) + (bounds.width - intrinsicContentSize.width) / 2
        let centerPage = centerDots / 2 + pageOffset
        
        dots.enumerated().forEach { page, dot in
            let center = CGPoint(x: horizontalOffset + bounds.minX + dotSize / 2 + (dotSize + spacing) * CGFloat(page),
                                 y: bounds.midY)
            let scale: CGFloat = {
                let distance = abs(page - centerPage)
                if distance > (maxDots / 2) {
                    return 0
                }
                return [1, 0.66, 0.66, 0.16][max(0, min(3, distance - centerDots / 2))]
            }()
            dot.center = center
            dot.transform = CGAffineTransform(scaleX: scale, y: scale)
        }
    }
}
