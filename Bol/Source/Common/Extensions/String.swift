//
//  String.swift
//  Bol
//
//  Created by Abdelrahman Ali on 19/12/2020.
//

import Foundation

extension String {
    
    /// A variable that returns the localized value associated to the string as a key
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
