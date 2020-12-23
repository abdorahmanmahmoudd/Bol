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
}

// MARK: - ProductDetails Mocked data
extension MockResponseData {

    func mockProductDetails() -> ProductDetails? {
        return (try? JSONDecoder().decode(ProductDetails.self, from: getJSONFrom(resource: "Stubs/ProductDetails-Success")))
    }
}
