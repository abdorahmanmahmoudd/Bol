//
//  ProductDetails.swift
//  Bol
//
//  Created by Abdelrahman Ali on 20/12/2020.
//

import Foundation

struct ProductDetails: Decodable {
    
    /// The API returns an array of Products but we only look for the first one
    private let products: [Product]?
    
    /// First product of the list.
    var product: Product?
    
    enum CodingKeys: CodingKey {
        case products
    }
    
    init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        products = try container.decode([Product].self, forKey: .products)
        
        product = products?.first
    }
}
