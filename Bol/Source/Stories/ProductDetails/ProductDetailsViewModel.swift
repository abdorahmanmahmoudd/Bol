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
    
    /// Product Accessories
    private(set) var accessoryIds: [ProductId]?
    private(set) var accessories: BehaviorSubject<[Product]> = .init(value: [])
    
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
        
        _ = productDetailsAPI.fetchProductDetails(productId: productId).subscribe(onSuccess: { [weak self] response in
            
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
    
    func fetchProductAccessories(dataset: String = "accessories,productfamily") {
        
        _ = productDetailsAPI.fetchRelatedProducts(productId: productId, dataset: dataset).subscribe(onSuccess: { [weak self] response in
            
            guard let self = self else {
                return
            }
            
            self.accessoryIds = response?.accessories
            self.fetchAccessoriesDetails()
            
        }, onError: { [weak self] error in
            
            self?.errorState(error)

        }).disposed(by: disposeBag)
    }
    
    private func fetchAccessoriesDetails() {
        
        guard let ids = accessoryIds else {
            return
        }
        
        let productDetailsRequests = ids.map({
            return productDetailsAPI.fetchProductDetails(productId: $0.productId)
        })
        
        Single.zip(productDetailsRequests)
            .observeOn(MainScheduler.asyncInstance)
            .do(onSuccess: { [weak self] productsDetails in
                
                guard let self = self else {
                    return
                }
                
                self.accessories.on(.next(productsDetails.compactMap({ $0?.product })))
                
            }, onError: { [weak self] error in
                
                self?.errorState(error)
                
            }).subscribe().disposed(by: disposeBag)
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
