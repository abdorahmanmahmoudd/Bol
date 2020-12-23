//
//  MockProductDetailsRepository.swift
//  BolTests
//
//  Created by Abdelrahman Ali on 23/12/2020.
//

import XCTest
import RxSwift
@testable import Bol

final class MockProductDetailsRepository: API, ProductDetailsRepository {
    
    /// Configuration for Success or Faulier
    let config: MockRepositoryConfig
    
    init(config: MockRepositoryConfig) {
        self.config = config
    }
    
    func fetchProductDetails(productId: String) -> Single<ProductDetails?> {
        switch config {
        case .success:
            return MockAPIResponse(config: .success).productDetailsResponse()
        default:
            return MockAPIResponse(config: .error).productDetailsResponse()
        }
    }
}
