//
//  Product.swift
//  Bol
//
//  Created by Abdelrahman Ali on 20/12/2020.
//

import Foundation

struct Product: Decodable {
    let id: String
    let ean: String?
    let gpc: String?
    let title: String?
    let subtitle: String?
    let specsTag: String?
    let summary: String?
    let rating: Int?
    let shortDescription: String?
    let longDescription: String?
    let urls: [ProductURL]?
    let images: [ProductImage]?
    let media: [ProductImage]?
    let offerData: ProductOffer?
    let parentCategoryPaths: [ProductParentCategoryPath]?
}

struct ProductURL: Decodable {
    let key: String?
    let value: String?
}

struct ProductImage: Decodable {
    let type: String?
    let key: String?
    let url: String?
}
