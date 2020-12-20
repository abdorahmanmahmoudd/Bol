//
//  ProductOffer.swift
//  Bol
//
//  Created by Abdelrahman Ali on 20/12/2020.
//

import Foundation

struct ProductOffer: Decodable {
    let bolCom: Int?
    let nonProfessionalSellers: Int?
    let professionalSellers: Int?
    let offers: [Offer]?
}

struct Offer: Decodable {
    let id: String
    let condition: String?
    let price: Float?
    let listPrice: Float?
    let availabilityCode: String
    let availabilityDescription: String?
    let seller: ProductSeller?
    let bestOffer: Bool?
    let releaseDate: String?
}
