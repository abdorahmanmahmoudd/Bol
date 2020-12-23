//
//  URLComponents.swift
//  Bol
//
//  Created by Abdelrahman Ali on 20/12/2020.
//

import Foundation

extension URLComponents {
    
    mutating func setQueryItems(parameters: [String: String]) {

        self.queryItems = parameters.map({
            return URLQueryItem(name: $0.key, value: $0.value)
        })

        /// Append the API key to all the API requests
        self.queryItems?.append(URLQueryItem(name: "apikey", value: Constants.apiKey))
    }
}
