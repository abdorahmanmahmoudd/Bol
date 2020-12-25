//
//  ProductsListViewModel.swift
//  Bol
//
//  Created by Abdelrahman Ali on 19/12/2020.
//

import Foundation
import RxSwift

final class ProductsListViewModel: BaseStateController {
    
    /// Network requests
    private let productsListAPI: ProductsListRepository
    
    /// Products List Observer
    private var productsListObserver: PublishSubject<[Product]> = .init()
    
    /// Product List
    private var productsList: [Product] = []
    
    /// RxSwift
    private let disposeBag = DisposeBag()
    
    /// default Page limit
    private var pageLimit = 10
    
    /// Current Page number
    private var pageNumber = 0
    
    /// Total items for Pagination
    private var totalItems = 0
    
    init(_ productsListAPI: ProductsListRepository) {
        self.productsListAPI = productsListAPI
    }
}


// MARK: APIs
extension ProductsListViewModel {
    
    /// Fetch Product List API call
    func fetchProductsList(_ offset: Int = 0, isRefreshing: Bool = false, isFetchingNextPage: Bool = false) {
        
        /// If not refreshing show loading indicator
        if !isRefreshing && !isFetchingNextPage {
            loadingState()
        }
        
        _ = productsListAPI.fetchProductsList(offset: offset).subscribe(onSuccess: { [weak self] response in
            
            guard let self = self else {
                return
            }
            
            /// If refreshing, remove the old content
            if isRefreshing {
                self.productsList.removeAll()
            }

            self.productsList.append(contentsOf: response?.products ?? [])
            self.totalItems = response?.totalResultSize ?? 0
            
            /// Call the result state callback
            self.resultState()
            
        }) { [weak self] error in
            
            guard let self = self else {
                return
            }
            
            self.errorState(error)

        }.disposed(by: disposeBag)
    }
    
    /// Get next products page
    func getNextPage() {
        pageNumber += 1
        fetchProductsList(pageNumber * pageLimit, isFetchingNextPage: true)
    }
    
    /// Refresh the content
    func refreshProducts() {
        pageNumber = 0
        fetchProductsList(isRefreshing: true)
    }
     
}

// MARK: Datasource
extension ProductsListViewModel {

    func numberOfRows() -> Int {
        return productsList.count
    }
    
    func item(at indexPath: IndexPath) -> Product {
        return productsList[indexPath.row]
    }
    
    func isEmpty() -> Bool {
        return productsList.count == 0
    }

    /// Returns whether you should get the next page or not
    func shouldGetNextPage(withCellIndex index: Int) -> Bool{
        
        /// if reached the last cell && not reached the total number of items then reload next page
        if index == productsList.count - 1 {
            if totalItems > productsList.count {
                return true
            }
        }
        return false
    }
}
