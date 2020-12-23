//
//  MockProductsListRepository.swift
//  BolTests
//
//  Created by Abdelrahman Ali on 23/12/2020.
//

import XCTest
import RxSwift
@testable import Bol

final class MockProductsListRepository: API, ProductsListRepository {
    
    /// Configuration for Success or Faulier
    let config: MockRepositoryConfig
    
    init(config: MockRepositoryConfig) {
        self.config = config
    }
    
    func fetchProductsList(offset: Int) -> Single<ProductsList?> {
        switch config {
        case .success:
            return MockAPIResponse(config: .success).productsListResponse()
        default:
            return MockAPIResponse(config: .error).productsListResponse()
        }
    }
}
