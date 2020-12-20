//
//  ResuableIdentifier.swift
//  Bol
//
//  Created by Abdelrahman Ali on 20/12/2020.
//

import Foundation

/// Default identifier added to UIViews
protocol ReusableIdentifier {
    static var identifier: String { get }
}

extension ReusableIdentifier {
    static var identifier: String {
        return String(describing: Self.self)
    }
}
