//
//  ProductDetailsUITests.swift
//  BolUITests
//
//  Created by Abdelrahman Ali on 25/12/2020.
//

import XCTest

class ProductDetailsUITests: XCTestCase {

    // Test ProductDetails views setup correctly
    func testSelectedProductsDetailsFilling() {
        
        // Given
        let app = XCUIApplication()
        
        app.launchEnvironment = [Constants.UITesting.uiTestingRunning: "0"]
        app.launch()

        let collectionView = app.collectionViews[AccessibilityIdentifiers.productsCollectionView.rawValue]
        XCTAssertTrue(collectionView.exists, "Products collectionView exists")

        // When
        let staticTextIdentifier = "Apple AirPods 2 - Niet draadloze oplaadcase"
        let cell = collectionView.cells.containing(.staticText, identifier: staticTextIdentifier).staticTexts[staticTextIdentifier]
        collectionView.scrollToElement(element: cell)
        cell.tap()
                
        // Then
        let imagesCollectionView = app.collectionViews[AccessibilityIdentifiers.productDetailsImagesCollectionView.rawValue]
        XCTAssertTrue(imagesCollectionView.exists, "ProductImages collectionView exists")
        
        let imagesPageControl = app.otherElements[AccessibilityIdentifiers.productDetailsImagesPageControl.rawValue]
        XCTAssertTrue(imagesPageControl.exists, "imagesPageControl exists")
        
        XCTAssertEqual(app.staticTexts[AccessibilityIdentifiers.productDetailsProductName.rawValue].label, staticTextIdentifier)
        XCTAssertEqual(app.staticTexts[AccessibilityIdentifiers.productDetailsSeller.rawValue].label, "Apple")
        
        let productDetailsPriceView = app.otherElements[AccessibilityIdentifiers.productDetailsPriceView.rawValue]
        XCTAssertTrue(productDetailsPriceView.exists, "productDetailsPriceView exists")
        
        let productDetailsRatingView = app.otherElements[AccessibilityIdentifiers.productDetailsRatingView.rawValue]
        XCTAssertTrue(productDetailsRatingView.exists, "productDetailsRatingView exists")
        
                let productDetailsAvailibilityView = app.otherElements[AccessibilityIdentifiers.productDetailsAvailibilityView.rawValue]
        XCTAssertTrue(productDetailsAvailibilityView.exists, "productDetailsAvailibilityView exists")
        
        let accessoriesView = app.otherElements[AccessibilityIdentifiers.accessoriesCarouselView.rawValue]
        XCTAssertTrue(accessoriesView.exists, "accessoriesView exists")
    }
}
