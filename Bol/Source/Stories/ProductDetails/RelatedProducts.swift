//
//  RelatedProducts.swift
//  Bol
//
//  Created by Abdelrahman Ali on 25/12/2020.
//

import Foundation

struct RelatedProducts: Decodable {
    let accessories: [ProductId]?
}

struct ProductId: Decodable {
    let productId: String
}
