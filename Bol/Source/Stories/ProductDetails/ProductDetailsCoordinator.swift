//
//  ProductDetailsCoordinator.swift
//  Bol
//
//  Created by Abdelrahman Ali on 20/12/2020.
//

import UIKit

final class ProductDetailsCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    var api: NetworkRepository
    
    weak var parentCoordinator: Coordinator?
    
    /// Selected Product Id
    var productId: String
    
    init(_ navigationController: UINavigationController, _ api: NetworkRepository, productId: String) {
        
        self.navigationController = navigationController
        self.api = api
        self.productId = productId
    }
    
    func start() {
        
        let productDetailsViewModel = ProductDetailsViewModel(api.productDetailsAPI, productId: productId)
        let productDetailsViewController = ProductDetailsViewController.create(payload: productDetailsViewModel)
        productDetailsViewController.coordinator = self
        navigationController.pushViewController(productDetailsViewController, animated: true)
    }
    
    func didSelectProduct(with Id: String) {
        
        let productDetailsCoordinator = ProductDetailsCoordinator(navigationController, api, productId: Id)
        productDetailsCoordinator.parentCoordinator = self
        addChildCoordinator(productDetailsCoordinator)
        productDetailsCoordinator.start()
    }
}

// MARK: Additional behaviour
extension ProductDetailsCoordinator {
    
    /// After pop animation is done etc..
    func didFinish() {
        (parentCoordinator as? ProductsListCoordinator)?.childDidFinish(self)
    }
}
