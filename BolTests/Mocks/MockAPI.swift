//
//  MockAPI.swift
//  BolTests
//
//  Created by Abdelrahman Ali on 23/12/2020.
//
import XCTest
import RxSwift
@testable import Bol

/// Mocked repository failure configuration
enum MockError: Error {
    case error
    case noData
    case decodingError
}

/// Mocked repository response configuration
enum MockRepositoryConfig {
    case success
    case empty
    case error
}

// MARK: Mock API shared Client
final class MockAPI: NetworkRepository {
    
    var productsListAPI: ProductsListRepository
    var productDetailsAPI: ProductDetailsRepository
    
    /// Config for Succes or Failure
    private let config: MockRepositoryConfig
    
    init(config: MockRepositoryConfig) {
        self.config = config
        productsListAPI = MockProductsListRepository(config: config)
        productDetailsAPI = MockProductDetailsRepository(config: config)
    }
}
