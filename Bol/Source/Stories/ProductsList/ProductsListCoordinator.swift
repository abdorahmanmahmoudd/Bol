//
//  ProductsListCoordinator.swift
//  Bol
//
//  Created by Abdelrahman Ali on 19/12/2020.
//

import UIKit

final class ProductsListCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    var api: NetworkRepository
    
    init(_ api: NetworkRepository) {
        self.navigationController = UINavigationController()
        self.navigationController.tabBarItem = UITabBarItem(title: "", image: #imageLiteral(resourceName: "baseline_home_black_24pt"), selectedImage: #imageLiteral(resourceName: "outline_home_black_24pt"))
        self.api = api
    }
    
    func start() {
        
        let productsListViewModel = ProductsListViewModel(api.productsListAPI)
        let productsListViewController = ProductsListViewController.create(payload: productsListViewModel)
        productsListViewController.coordinator = self
        navigationController.setViewControllers([productsListViewController], animated: true)
    }
    
    func didSelectProduct(with Id: String) {
        
        let productDetailsCoordinator = ProductDetailsCoordinator(navigationController, api, productId: Id)
        productDetailsCoordinator.parentCoordinator = self
        addChildCoordinator(productDetailsCoordinator)
        productDetailsCoordinator.start()
    }
}

// MARK: Additional behaviour
extension ProductsListCoordinator {
    
    func childDidFinish(_ child: Coordinator) {
        
        switch child.self {
        case is ProductDetailsCoordinator:
            debugPrint("ProductDetailsCoordinator didFinish")
            
        default:
            debugPrint("childDidFinish not handling \(child)")
        }
        
        removeChildCoordinator(child)
    }
}
