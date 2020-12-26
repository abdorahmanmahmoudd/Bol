//
//  ProductDetailsRepository.swift
//  Bol
//
//  Created by Abdelrahman Ali on 20/12/2020.
//

import Foundation
import RxSwift

/// A protocol for each story repository to make it testable and injectable by any implementation
protocol ProductDetailsRepository {
    func fetchProductDetails(productId: String) -> Single<ProductDetails?>
    func fetchRelatedProducts(productId: String, dataset: String) -> Single<RelatedProducts?>
}

/// Every repository implementation should subclass the `API`
final class ProductDetailsAPI: API, ProductDetailsRepository {
    
    func fetchProductDetails(productId: String) -> Single<ProductDetails?> {
        
        guard var urlComponents = URLComponents(string: urlOfType(.production)) else {
            return .error(API.Error.invalidURLHost)
        }

        let path = "/catalog/v4/products/\(productId)"
        urlComponents.path = path
        
        /// To add the API key, for development purposes
        urlComponents.setQueryItems(parameters: [:])
        
        guard let url = urlComponents.url else {
            return .error(API.Error.invalidURLPath)
        }

        return response(for: url).observeOn(MainScheduler.instance)
    }
    
    func fetchRelatedProducts(productId: String, dataset: String) -> Single<RelatedProducts?> {
        
        guard var urlComponents = URLComponents(string: urlOfType(.production)) else {
            return .error(API.Error.invalidURLHost)
        }

        let path = "/catalog/v4/relatedproducts/\(productId)"
        urlComponents.path = path
        
        /// To add the API key, for development purposes
        urlComponents.setQueryItems(parameters: ["dataset": dataset])
        
        guard let url = urlComponents.url else {
            return .error(API.Error.invalidURLPath)
        }

        return response(for: url).observeOn(MainScheduler.instance)
    }
}
