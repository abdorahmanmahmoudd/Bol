//
//  ProductsListTests.swift
//  BolTests
//
//  Created by Abdelrahman Ali on 23/12/2020.
//

import XCTest
import RxSwift
import RxBlocking
@testable import Bol

class ProductsListTests: XCTestCase {

    /// Returns `ProductsListViewModel` injected with `MockRepositoryConfig`
    private func productsListViewModel(responseType: MockRepositoryConfig) -> ProductsListViewModel {
        
        let api = MockAPI(config: responseType)
        return ProductsListViewModel(api.productsListAPI)
    }

    func testProductsList_success() {
        
        /// Given
        let viewModel = productsListViewModel(responseType: .success)
        
        /// Then
        viewModel.refreshState = {
            
            switch viewModel.state {
            case .result:
                /// Then
                XCTAssert(!viewModel.isEmpty())
            case .error:
                /// Then
                XCTAssert(false)
            default:
                break
            }
        }
        
        /// When
        viewModel.fetchProductsList()
    }
}
