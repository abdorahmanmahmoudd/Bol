//
//  ProductsListTests.swift
//  BolTests
//
//  Created by Abdelrahman Ali on 23/12/2020.
//

import XCTest
import RxSwift
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
    
    func testProductsList_empty() {
        
        /// Given
        let viewModel = productsListViewModel(responseType: .empty)
        
        /// Then
        viewModel.refreshState = {
            
            switch viewModel.state {
            case .result:
                /// Then
                XCTAssert(viewModel.isEmpty())
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
    
    func testProductsList_failure() {
        
        /// Given
        let viewModel = productsListViewModel(responseType: .error)
        
        /// Then
        viewModel.refreshState = {
            
            switch viewModel.state {
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
        viewModel.fetchProductsList()
    }
  
    func testProductsList_nextPage() {
        
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
        
        /// Then
        if viewModel.shouldGetNextPage(withCellIndex: 7) {
            viewModel.getNextPage()
        }
    }
    
    func testProductsList_refreshProducts() {
        
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
        
        /// When
        viewModel.refreshProducts()
    }
    
    func testProductsList_itemAt() {
        
        /// Given
        let viewModel = productsListViewModel(responseType: .success)
        
        /// Then
        viewModel.refreshState = {
            
            switch viewModel.state {
            case .result:
                /// Then
                XCTAssertNotNil(viewModel.item(at: IndexPath(row: 0, section: 0)))
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
