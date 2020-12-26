//
//  ShadowStyle.swift
//  Bol
//
//  Created by Abdelrahman Ali on 23/12/2020.
//

import UIKit

// MARK: Shadows Enum represting the usable shadow styles
enum Shadows {
    
    case cardShadow
    
    func shadowStyle() -> ShadowStyle {
        switch self {
        case .cardShadow:
            return CardShadow()
        }
    }
}

// MARK: A protocol to define different type of shadow styles
protocol ShadowStyle {
  var color: UIColor { get }
  var alpha: Float { get }
  var inset: Bool { get }
  var hOffset: CGFloat { get }
  var vOffset: CGFloat { get }
  var blur: CGFloat { get }
  var spread: CGFloat { get }
}

// Example of a predefined shadow style
private struct CardShadow: ShadowStyle {
  let color: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
  let alpha: Float = 0.28
  let inset: Bool = false
  let hOffset: CGFloat = 0
  let vOffset: CGFloat = 2
  let blur: CGFloat = 7
  let spread: CGFloat = 2
}


