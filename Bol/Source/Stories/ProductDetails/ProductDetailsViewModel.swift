//
//  ProductDetailsViewModel.swift
//  Bol
//
//  Created by Abdelrahman Ali on 20/12/2020.
//

import Foundation
import RxSwift

final class ProductDetailsViewModel: BaseStateController {
    
    /// Network requests
    private let productDetailsAPI: ProductDetailsRepository
    
    /// Product
    private(set) var product: Product?
    
    /// Selected Product Id
    private var productId: String
    
    /// RxSwift
    private let disposeBag = DisposeBag()
    
    init(_ productDetailsAPI: ProductDetailsRepository, productId: String) {
        self.productDetailsAPI = productDetailsAPI
        self.productId = productId
    }
}

// MARK: APIs
extension ProductDetailsViewModel {
    
    func fetchProductDetails() {
        
        _ = productDetailsAPI.fetchProductDetails(productId: self.productId).subscribe(onSuccess: { [weak self] response in
            
            guard let self = self else {
                return
            }
            
            self.product = response?.product
            self.resultState()
            
        }, onError: { [weak self] error in
            
            guard let self = self else {
                return
            }
            
            self.errorState(error)

        }).disposed(by: disposeBag)
    }
}

// MARK: DataSource
extension ProductDetailsViewModel {
    
    func isEmpty() -> Bool {
        return product == nil
    }
    
    func productMedia() -> Int {
        return product?.media?.count ?? 0
    }
    
    func mediaURL(of index: Int) -> String {
        guard index < productMedia() else {
            return ""
        }
        return product?.media?[index].url ?? ""
    }
    
}
