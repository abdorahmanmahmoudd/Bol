//
//  ProductDetailsTests.swift
//  BolTests
//
//  Created by Abdelrahman Ali on 24/12/2020.
//

import XCTest
import RxSwift
@testable import Bol

class ProductDetailsTests: XCTestCase {

    /// Returns `ProductDetailsViewModel` injected with `MockRepositoryConfig`
    private func productDetailsViewModel(responseType: MockRepositoryConfig) -> ProductDetailsViewModel? {
        
        let api = MockAPI(config: responseType)
        guard let productId = MockResponseData().mockProductDetails()?.product?.id else {
            return nil
        }
        return ProductDetailsViewModel(api.productDetailsAPI, productId: productId)
    }
    
    func testProductDetails_Success() {
        /// Given
        let viewModel = productDetailsViewModel(responseType: .success)
        
        /// Then
        viewModel?.refreshState = {
            switch viewModel?.state {
            case .result:
                /// Then
                XCTAssertNotNil(viewModel?.product)
            case .error:
                /// Then
                XCTAssert(false)
            default:
                break
            }
        }
        
        /// When
        viewModel?.fetchProductDetails()
    }
    
    func testProductDetails_Empty() {
        /// Given
        let viewModel = productDetailsViewModel(responseType: .empty)
        
        /// Then
        viewModel?.refreshState = {
            switch viewModel?.state {
            case .result:
                /// Then
                XCTAssertNil(viewModel?.product)
            case .error:
                /// Then
                XCTAssert(false)
            default:
                break
            }
        }
        
        /// When
        viewModel?.fetchProductDetails()
    }

    func testProductDetails_Error() {
        /// Given
        let viewModel = productDetailsViewModel(responseType: .error)
        
        /// Then
        viewModel?.refreshState = {
            switch viewModel?.state {
            case .result:
                /// Then
                XCTAssert(false)
            case .error:
                /// Then
                XCTAssert(true)
            default:
                break
            }
        }
        
        /// When
        viewModel?.fetchProductDetails()
    }

}
