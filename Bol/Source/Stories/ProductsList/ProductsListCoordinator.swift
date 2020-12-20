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
    
    init(_ navigationController: UINavigationController, _ api: NetworkRepository) {
        self.navigationController = navigationController
        self.api = api
    }
    
    func start() {
        
        let productsListViewModel = ProductsListViewModel(api.productsListAPI)
        let productsListViewController = ProductsListViewController.create(payload: productsListViewModel)
        productsListViewController.coordinator = self
        navigationController.setViewControllers([productsListViewController], animated: true)
    }
}
