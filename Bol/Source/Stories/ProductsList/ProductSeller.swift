//
//  ProductSeller.swift
//  Bol
//
//  Created by Abdelrahman Ali on 20/12/2020.
//

import Foundation

struct ProductSeller: Decodable {
    let id: String
    let sellerType: String?
    let displayName: String?
    let url: String?
    let topSeller: Bool?
    let useWarrantyRepairConditions: Bool?
}
