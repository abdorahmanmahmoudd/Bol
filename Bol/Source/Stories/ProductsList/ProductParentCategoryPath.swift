//
//  ProductParentCategoryPath.swift
//  Bol
//
//  Created by Abdelrahman Ali on 20/12/2020.
//

import Foundation

struct ProductParentCategoryPath: Decodable {
    let parentCategories: [ParentCategoryPath]?
}

struct ParentCategoryPath: Decodable {
    let id: String?
    let name: String?
}
