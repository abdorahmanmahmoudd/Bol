//
//  ProductsListViewController.swift
//  Bol
//
//  Created by Abdelrahman Ali on 19/12/2020.
//

import UIKit
import RxSwift
import RxCocoa

final class ProductsListViewController: BaseViewController {

    /// Products  table view
    private var productsTableView = UITableView()
    
    /// `ProductsListViewModel`
    private var viewModel: ProductsListViewModel!
    
    /// Refresh control
    private let refreshControl = UIRefreshControl()
    
    /// RxSwift
    private let disposeBag = DisposeBag()


    override func viewDidLoad() {
        super.viewDidLoad()

        /// Set navigation bar title
        styleNavigationItem()
        
        /// Configure news table view and add it
        view.addSubview(productsTableView)
        configureProductsTableView()
        
        /// Bind reactive observables
        bindObservables()
        
        /// Request arts list
        viewModel.fetchProductsList()
    }
    
    /// Set navigation item style
    private func styleNavigationItem() {
        
        title = "PRODUCTS_LIST_TITLE".localized
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.systemBlue, NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)]
    }

    /// Configure Products table view
    private func configureProductsTableView() {
        
        /// Set delegate, datasource and refresh control
        productsTableView.delegate = self
        productsTableView.dataSource = self
        productsTableView.refreshControl = refreshControl
        productsTableView.separatorStyle = .none
        
        /// Register the cell
        let productCellNib = UINib(nibName: ProductTableViewCell.identifier, bundle: nil)
        productsTableView.register(productCellNib, forCellReuseIdentifier: ProductTableViewCell.identifier)
        
        /// Activate constraints and set row height to Automatic Dimension
        productsTableView.activateConstraints(for: view)
        productsTableView.rowHeight = UITableView.automaticDimension
        productsTableView.estimatedRowHeight = 180
    }
    
    private func bindObservables() {
        
        /// Set view model state change callback
        viewModel.refreshState = { [weak self] in
            
            guard let self = self else {
                return
            }
            
            /// end refreshing anyways
            self.refreshControl.endRefreshing()
            
            switch self.viewModel.state {
                
            case .initial:
                debugPrint("initial ProductsListViewController")
                
            case .loading:
                debugPrint("loading ProductsListViewController")
                self.showLoadingIndicator(visible: true)
                
                
            case .error(let error):
                debugPrint("error \(String(describing: error))")
                self.showLoadingIndicator(visible: false)
                
                /// If there is an error then show error view with that error and try again button
                self.showError(with: "GENERAL_EMPTY_STATE_ERROR".localized, message: error?.localizedDescription, retry: {
                    self.viewModel.fetchProductsList()
                })
                return
                
            case .result:
                debugPrint("Result ProductsListViewController")
                self.showLoadingIndicator(visible: false)
                
                /// If there is no results then show a message with a try again button
                if self.viewModel.isEmpty() {
                    
                    self.showError(with: "GENERAL_EMPTY_STATE_ERROR".localized, retry: {
                        self.viewModel.fetchProductsList()
                    })
                    return
                }
                self.removeErrorView()
                self.productsTableView.reloadData()
            }
        }
        
        /// Bind Refresh control value changed event to refresh the content
        refreshControl.rx.controlEvent(.valueChanged)
            .asObservable()
            .debounce(RxTimeInterval.seconds(1), scheduler: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] in
                
                guard let self = self else {
                    return
                }

                self.viewModel.refreshProducts()
                
            }).disposed(by: disposeBag)
    }
    
    /// Open `ProductDetailsViewController` with selected ArtObject
//    private func pushArtDetails(with indexPath: IndexPath) {
//
//        let artDetailViewModel = ArtDetailsViewModel(art: viewModel.item(at: indexPath), api: viewModel.api)
//        let artDetailsViewController = ArtDetailsViewController.create(payload: artDetailViewModel)
//        navigationController?.pushViewController(artDetailsViewController, animated: true)
//    }
}

// MARK: UITableViewDataSource
extension ProductsListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProductTableViewCell.identifier,
                                                       for: indexPath) as? ProductTableViewCell else {
            fatalError("Couldn't dequeue a cell!")
        }

        cell.configure(with: viewModel.item(at: indexPath))
        return cell
    }
}

// MARK: UITableViewDelegate
extension ProductsListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        /// Do not fetch next page during  specific UI tests
//        #if DEBUG
//        if UIApplication.isUITestingEnabled {
//            return
//        }
//        #endif
        
        /// check if we should fetch the next page
        if viewModel.shouldGetNextPage(withCellIndex: indexPath.row) {
            viewModel.getNextPage()
        }
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        pushProductDetails(with: indexPath)
//    }
}

// MARK: Injectable
extension ProductsListViewController: Injectable {

    typealias Payload = ProductsListViewModel

    func inject(payload: ProductsListViewModel) {
        viewModel = payload
    }

    func assertInjection() {
        assert(viewModel != nil)
    }
}

// MARK: Accessibility
extension ProductsListViewController {

    override func setAccessibilityIdentifiers(){
        super.setAccessibilityIdentifiers()
        
        productsTableView.accessibilityIdentifier = AccessibilityIdentifiers.rijksListTableView.rawValue
        productsTableView.isAccessibilityElement = false
    }
}


