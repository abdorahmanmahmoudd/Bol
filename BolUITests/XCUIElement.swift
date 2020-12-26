//
//  XCUIElement.swift
//  BolUITests
//
//  Created by Abdelrahman Ali on 26/12/2020.
//

import XCTest

extension XCUIElement {
    
    func scrollToElement(element: XCUIElement) {
        while !element.visible() {
            swipeUp()
        }
    }
    
    func visible() -> Bool {
        guard exists && !frame.isEmpty else {
            return false
        }
        return XCUIApplication().windows.element(boundBy: 0).frame.contains(frame)
    }
}
