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
    case empty
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
                
            case .empty:
                let emptyList = MockResponseData().mockEmptyProductsList()
                single(.success(emptyList))
                
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
            case .success:
                let productDetails = MockResponseData().mockProductDetails()
                single(.success(productDetails))
                
            case .empty:
                let emptyProductDetails = MockResponseData().mockEmptyProductDetails()
                single(.success(emptyProductDetails))
                
            default:
                single(.error(MockError.decodingError))
            }
            
            return Disposables.create()
        })
    }
    
    func relatedProductsResponse() -> Single<RelatedProducts?> {
        
        return Single<RelatedProducts?>.create(subscribe: { single -> Disposable in
            
            switch self.config {
            case .success:
                let relatedProducts = MockResponseData().mockRelatedProducts()
                single(.success(relatedProducts))
                
            case .empty:
                let emptyRelatedProducts = MockResponseData().mockEmptyRelatedProducts()
                single(.success(emptyRelatedProducts))
                
            default:
                single(.error(MockError.decodingError))
            }
            
            return Disposables.create()
        })
    }
}
