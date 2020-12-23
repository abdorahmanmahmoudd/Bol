//
//  CALayer.swift
//  Bol
//
//  Created by Abdelrahman Ali on 23/12/2020.
//

import UIKit
 
extension CALayer {
    
    /// A helper function to apply shadow style
    func shadow(shadow: Shadows) {
        
        let style = shadow.shadowStyle()

        shadowColor = style.color.cgColor
        shadowOpacity = style.alpha
        shadowOffset = CGSize(width: style.hOffset, height: style.vOffset)
        shadowRadius = style.blur / 2.0

        if style.spread == 0 {
            shadowPath = nil
            
        } else {
            let deltaX = -style.spread
            let rect = bounds.insetBy(dx: deltaX, dy: deltaX)
            shadowPath = UIBezierPath(rect: rect).cgPath
        }
    }
}
