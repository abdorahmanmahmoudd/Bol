//
//  BaseViewController.swift
//  Bol
//
//  Created by Abdelrahman Ali on 20/12/2020.
//

import UIKit
import PKHUD

class BaseViewController: UIViewController, UIGestureRecognizerDelegate {
    
    /// Error View Controller
    lazy var errorViewController = ErrorViewController()
    
    /// View controller's Coordinator
    weak var coordinator: Coordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /// Enable swipe back gesture
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        /// Setup accessibility
        setAccessibilityIdentifiers()
    }

    /// Disable pop gesture in one situation:
    /// 1) when we are on the root view controller
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard gestureRecognizer == navigationController?.interactivePopGestureRecognizer else {
            return true
        }
        return (navigationController?.viewControllers.count ?? 0) > 1 ? true : false
    }

    /// Show and hide loading indicator
    func showLoadingIndicator(visible: Bool) {
        PKHUD.sharedHUD.contentView = PKHUDSystemActivityIndicatorView()
        visible ? PKHUD.sharedHUD.show(onView: view) : PKHUD.sharedHUD.hide()
    }
    
    /// Shared Error Handling functionality
    func handleError(_ error: Error?) {
        debugPrint("error \(String(describing: error))")
        self.showLoadingIndicator(visible: false)
        
        /// If there is an error then show error view with that error and try again button
        self.showError(with: "GENERAL_EMPTY_STATE_ERROR".localized, message: error?.localizedDescription, retry: {
            self.retry()
        })
        return
    }
    
    /// To be overrwitten by subclasses
    func retry() {
        debugPrint("Override by view controller subclass")
    }
}

// MARK: Error View
extension BaseViewController {
    
    /// Present error  view with title, message and callback
    func showError(with title: String? = "", message: String? = "", retry: @escaping () -> ()) {
        errorViewController.loadViewIfNeeded()
        errorViewController.setError(withTitle: title, andMessage: message)
        errorViewController.action = retry
        transition(to: errorViewController)
    }
    
    /// Present Error view controller
    private func transition(to viewController: UIViewController) {
        
        /// Remove old error view if exists
        removeErrorView()
        
        /// Add the new error view
        viewController.willMove(toParent: self)
        addChild(viewController)
        view.addSubview(viewController.view)
        viewController.didMove(toParent: self)
        
        /// Activate the constraints for the new error view
        errorViewController.view.activateConstraints(for: self.view)
    }
    
    /// Remove Error View Controller
    func removeErrorView() {

        if errorViewController.parent != nil {
            errorViewController.willMove(toParent: nil)
            errorViewController.removeFromParent()
            errorViewController.view.removeFromSuperview()
            errorViewController.didMove(toParent: nil)
        }
    }
}

// MARK: Accessibility
extension BaseViewController {
    
    @objc func setAccessibilityIdentifiers() {
        // To be overwritten
        errorViewController.view.accessibilityIdentifier = AccessibilityIdentifiers.errorView.rawValue
        errorViewController.view.isAccessibilityElement = true
        
        PKHUD.sharedHUD.contentView.accessibilityIdentifier = AccessibilityIdentifiers.loadingIndicator.rawValue
        PKHUD.sharedHUD.contentView.isAccessibilityElement = true
    }
}


