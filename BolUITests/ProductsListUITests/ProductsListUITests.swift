//
//  ProductsListUITests.swift
//  BolUITests
//
//  Created by Abdelrahman Ali on 24/12/2020.
//

import XCTest

class ProductsListUITests: XCTestCase {

    // Test ProductsListCollectionView exists and has cells
    func testProductsListCells() {
        // Given
        let app = XCUIApplication()
        
        // When
        app.launch()
        
        // Then
        XCTAssert(app.collectionViews[AccessibilityIdentifiers.productsCollectionView.rawValue].cells.count > 0)
    }
}
