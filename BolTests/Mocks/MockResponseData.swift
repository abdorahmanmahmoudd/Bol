//
//  MockResponseData.swift
//  BolTests
//
//  Created by Abdelrahman Ali on 23/12/2020.
//

import XCTest
import RxSwift
@testable import Bol

// MARK: A class that helps to mock the responses data
final class MockResponseData: XCTestCase {}

// MARK: - ProductsList Mocked data
extension MockResponseData {

    func mockProductsList() -> ProductsList? {
        return (try? JSONDecoder().decode(ProductsList.self, from: getJSONFrom(resource: "Stubs/ProductsList-Success")))
    }
    
    func mockEmptyProductsList() -> ProductsList? {
        return (try? JSONDecoder().decode(ProductsList.self, from: getJSONFrom(resource: "Stubs/ProductsList-Empty")))
    }
}

// MARK: - ProductDetails Mocked data
extension MockResponseData {

    func mockProductDetails() -> ProductDetails? {
        return (try? JSONDecoder().decode(ProductDetails.self, from: getJSONFrom(resource: "Stubs/ProductDetails-Success")))
    }
    
    func mockEmptyProductDetails() -> ProductDetails? {
        return (try? JSONDecoder().decode(ProductDetails.self, from: getJSONFrom(resource: "Stubs/ProductDetails-Empty")))
    }
    
    func mockRelatedProducts() -> RelatedProducts? {
        return (try? JSONDecoder().decode(RelatedProducts.self, from: getJSONFrom(resource: "Stubs/RelatedProducts-Success")))
    }
    
    func mockEmptyRelatedProducts() -> RelatedProducts? {
        return (try? JSONDecoder().decode(RelatedProducts.self, from: getJSONFrom(resource: "Stubs/RelatedProducts-Empty")))
    }
}
