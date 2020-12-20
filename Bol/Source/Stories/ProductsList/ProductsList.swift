//
//  ProductsList.swift
//  Bol
//
//  Created by Abdelrahman Ali on 20/12/2020.
//

import Foundation

struct ProductsList: Decodable {
    let totalResultSize: Int?
    let products: [Product]?
}
