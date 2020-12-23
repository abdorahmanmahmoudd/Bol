//
//  ProductsListRepository.swift
//  Bol
//
//  Created by Abdelrahman Ali on 19/12/2020.
//

import Foundation
import RxSwift

/// A protocol for each story repository to make it testable and injectable by any implementation
protocol ProductsListRepository {
    func fetchProductsList(offset: Int) -> Single<ProductsList?>
}

/// Every repository implementation should subclass the `API`
final class ProductsListAPI: API, ProductsListRepository {
    
    func fetchProductsList(offset: Int) -> Single<ProductsList?> {
        
        guard var urlComponents = URLComponents(string: urlOfType(.production)) else {
            return .error(API.Error.invalidURLHost)
        }

        let path = "/catalog/v4/lists"
        urlComponents.path = path
        urlComponents.setQueryItems(parameters: ["offset": "\(offset)"])
        
        guard let url = urlComponents.url else {
            return .error(API.Error.invalidURLPath)
        }

        return response(for: url).observeOn(MainScheduler.instance)
    }
}
