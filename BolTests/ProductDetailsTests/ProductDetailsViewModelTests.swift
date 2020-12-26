//
//  ProductDetailsViewModelTests.swift
//  BolTests
//
//  Created by Abdelrahman Ali on 24/12/2020.
//

import XCTest
import RxSwift
import RxBlocking
@testable import Bol

class ProductDetailsViewModelTests: XCTestCase {
    
    let disposeBag = DisposeBag()

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
    
    func testRelatedProducts_Success() {
        /// Given
        let viewModel = productDetailsViewModel(responseType: .success)
        
        /// Create an expectation for products Accessories response
        let expectation = XCTestExpectation(description: "Accessories received successfully")

        /// Start the `RelatedProducts` request
        viewModel?.fetchProductAccessories()
        
        /// Wait for the Accessories response to be received within 5 secs.
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {

            /// check if accessories received
            XCTAssert(!(try! viewModel?.accessories.value().isEmpty ?? true))
            
            /// fulfill expectation
            expectation.fulfill()
        }

        /// Wait for the expectation to be fulfilled within 6 sec
        wait(for: [expectation], timeout: 6.0)
    }
    
    func testRelatedProducts_Empty() {
        /// Given
        let viewModel = productDetailsViewModel(responseType: .empty)
        
        /// Create an expectation for products Accessories response
        let expectation = XCTestExpectation(description: "Accessories isEmpty")

        /// Start the `RelatedProducts` request
        viewModel?.fetchProductAccessories()
        
        /// Wait for the Accessories response to be received within 5 secs.
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {

            /// check if accessories received
            XCTAssert((try! viewModel?.accessories.value().isEmpty ?? false))
            
            /// fulfill expectation
            expectation.fulfill()
        }

        /// Wait for the expectation to be fulfilled within 6 sec
        wait(for: [expectation], timeout: 6.0)
    }

    func testRelatedProducts_Error() {
        /// Given
        let viewModel = productDetailsViewModel(responseType: .error)
        
        /// Create an expectation for products Accessories response
        let expectation = XCTestExpectation(description: "Accessories Error")

        /// Start the `RelatedProducts` request
        viewModel?.fetchProductAccessories()
        
        /// Wait for the Accessories response to be received within 5 secs.
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {

            /// check if accessories received
            XCTAssert((try! viewModel?.accessories.value().isEmpty ?? false))
            
            /// fulfill expectation
            expectation.fulfill()
        }

        /// Wait for the expectation to be fulfilled within 6 sec
        wait(for: [expectation], timeout: 6.0)
    }

}
