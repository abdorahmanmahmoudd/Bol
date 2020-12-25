//
//  AccessibilityIdentifiers.swift
//  Bol
//
//  Created by Abdelrahman Ali on 20/12/2020.
//

import Foundation

// MARK: Accessibility identifiers used for UI testing setup.
enum AccessibilityIdentifiers: String {
    
    /// Common
    case loadingIndicator = "LoadingIndicator",
    errorView = "ErrorView",
    
    /// ProductsList
    productsCollectionView = "ProductsCollectionView",
    
    /// ProductDetails
    productDetailsImagesCollectionView = "ProductDetailsImagesCollectionView",
    productDetailsImagesPageControl = "ProductDetailsImagesPageControl",
    productDetailsProductName = "ProductDetailsProductName",
    productDetailsSeller = "ProductDetailsSeller",
    productDetailsPriceView = "ProductDetailsPriceView",
    productDetailsRatingView = "ProductDetailsRatingView",
    productDetailsAvailibilityView = "ProductDetailsAvailibilityView"
}
