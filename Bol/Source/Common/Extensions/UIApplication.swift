//
//  UIApplication.swift
//  Bol
//
//  Created by Abdelrahman Ali on 24/12/2020.
//

import UIKit

extension UIApplication {
    
    static var isUITestingEnabled: Bool {
        return ProcessInfo.processInfo.environment[Constants.UITesting.uiTestingRunning] == "0"
    }
}
