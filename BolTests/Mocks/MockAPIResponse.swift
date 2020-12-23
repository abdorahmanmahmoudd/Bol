//
//  MockAPIResponse.swift
//  BolTests
//
//  Created by Abdelrahman Ali on 23/12/2020.
//

import XCTest
import RxSwift
@testable import Bol

/// Mocked API response configuration
enum MockResponseConfig {
    case success
    case error
}

// MARK: Mock responses
struct MockAPIResponse {

    private let config: MockResponseConfig
    
    init(config: MockResponseConfig) {
        self.config = config
    }
}

// MARK: - ProductsList responses
extension MockAPIResponse {
    
    func productsListResponse() -> Single<ProductsList?> {
        
        return Single<ProductsList?>.create(subscribe: { single -> Disposable in
            
            switch self.config {
            case .error:
                single(.error(MockError.decodingError))
                
            case .success:
                let list = MockResponseData().mockProductsList()
                single(.success(list))
            }
            
            return Disposables.create()
        })
    }
}

// MARK: - Product Details responses
extension MockAPIResponse {
    
    func productDetailsResponse() -> Single<ProductDetails?> {
        
        return Single<ProductDetails?>.create(subscribe: { single -> Disposable in
            
            switch self.config {
            case .error:
                single(.error(MockError.decodingError))
                
            case .success:
                let productDetails = MockResponseData().mockProductDetails()
                single(.success(productDetails))
            }
            
            return Disposables.create()
        })
    }
}
