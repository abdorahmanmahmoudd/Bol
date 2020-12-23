//
//  XCTestCase.swift
//  BolTests
//
//  Created by Abdelrahman Ali on 23/12/2020.
//

import XCTest

extension XCTestCase {
    
    /// A helper method to find and get data from raw .json files.
    func getJSONFrom(resource: String) -> Data {

        guard let jsonURL = Bundle.main.url(forResource: resource, withExtension: "json"),
              let data = try? Data(contentsOf: jsonURL) else {
            
            XCTFail("Could not find JSON \(resource)")
            return Data()
        }
        
        return data
    }
}
