//
//  AppCoordinator.swift
//  Bol
//
//  Created by Abdelrahman Ali on 19/12/2020.
//

import UIKit

// MARK: Application main Coordinator that should kick off the app flow
final class AppCoordinator: Coordinator {
    
    /// Main Application window
    private(set) var window: UIWindow
    
    /// App API shared client
    private(set) var api: API = API()
    
    /// Coordinator navigation controller
    var navigationController: UINavigationController

    /// An array to track the childs coordinators
    var childCoordinators: [Coordinator] = []
    
    init(_ window: UIWindow) {
        navigationController = UINavigationController()
        self.window = window
        self.window.rootViewController = navigationController
        self.window.makeKeyAndVisible()
    }
    
    func start() {
//        startSplash()
        startProductsList()
    }
    
    func childDidFinish(_ child: Coordinator) {
        
//        switch child.self {
//
//        case is SplashCoordinator:
//            startStripsList()
//
//        default:
//            debugPrint("childDidFinish not handling \(child)")
//        }

        removeChildCoordinator(child)
    }
    
    func startProductsList() {
        let productsListCoordinator = ProductsListCoordinator(navigationController, api)
        addChildCoordinator(productsListCoordinator)
        productsListCoordinator.start()
    }
    
    func startSplash() {
//        let splashCoordinator = SplashCoordinator(navigationController)
//        addChildCoordinator(splashCoordinator)
//        splashCoordinator.parentCoordinator = self
//        splashCoordinator.start()
    }
}

