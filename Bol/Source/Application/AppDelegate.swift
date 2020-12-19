//
//  AppDelegate.swift
//  Bol
//
//  Created by Abdelrahman Ali on 11/12/2020.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    /// The application starting point
    private var appCoordinator: AppCoordinator?
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        /// Initialize `UIWindow` and pass it the `AppCoordinator` to kick off the app flow
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        
        appCoordinator = AppCoordinator(window)
        appCoordinator?.start()
        
        return true
    }
}

