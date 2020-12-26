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

    /// Products  collection view
    private var productsCollectionView: UICollectionView?
    private let collectionViewSectionInsets = UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 8)
    private let minimumInterspace: CGFloat = 4
    
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
        
        /// Configure news collection view and add it
        configureProductsCollectionView()
        
        /// Bind reactive observables
        bindObservables()
        
        /// Request arts list
        viewModel.fetchProductsList()
    }
    
    /// Set navigation item style
    private func styleNavigationItem() {
        
        /// set navigation item title view
        let logoImage = #imageLiteral(resourceName: "bol")
        let logoImageView = UIImageView(image: logoImage)
        logoImageView.contentMode = .scaleAspectFit
        navigationItem.titleView = logoImageView
        
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.tintColor = UIColor.mainColor
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.hidesBarsOnSwipe = true
    }

    /// Configure Products collection view
    private func configureProductsCollectionView() {
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = collectionViewSectionInsets
        let collectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        
        /// Add the collection view and activate constraints
        view.addSubview(collectionView)
        collectionView.activateConstraints(for: view)
        
        /// Register the cell
        let productCellNib = UINib(nibName: ProductCollectionViewCell.identifier, bundle: nil)
        collectionView.register(productCellNib, forCellWithReuseIdentifier: ProductCollectionViewCell.identifier)
        
        /// Set delegate, datasource and refresh control
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.refreshControl = refreshControl

        productsCollectionView = collectionView
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
                self.handleError(error)
                
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
                self.productsCollectionView?.reloadData()
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
    
    /// Retry block when error happens.
    override func retry() {
        self.viewModel.fetchProductsList()
    }
}

// MARK: UICollectionViewDataSource
extension ProductsListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfRows()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.identifier,
                                                            for: indexPath) as? ProductCollectionViewCell else {
            
            fatalError("Couldn't dequeue a cell! \(ProductCollectionViewCell.description())")
        }

        cell.configure(with: viewModel.item(at: indexPath))
        return cell
    }
}

// MARK: UICollectionViewDelegate
extension ProductsListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        /// Do not fetch next page during UI tests
        #if DEBUG
        if UIApplication.isUITestingEnabled {
            return
        }
        #endif
        
        /// check if we should fetch the next page
        if viewModel.shouldGetNextPage(withCellIndex: indexPath.row) {
            viewModel.getNextPage()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        /// Open `ProductDetailsViewController` with selected Product
        (coordinator as? ProductsListCoordinator)?.didSelectProduct(with: viewModel.item(at: indexPath).id)
    }
}

// MARK: UICollectionViewFlowlayoutDelegate
extension ProductsListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize()
    }
    
    /// Calculates the cell size
    private func cellSize() -> CGSize {
        
        let cellWidth: CGFloat = (UIScreen.main.bounds.width - minimumInterspace - (collectionViewSectionInsets.left + collectionViewSectionInsets.right)) / 2.0
        
        /// Apply 3:2 ratio for iPhone, else apply 4:3 ratio
        let cellHeight = UIDevice.current.userInterfaceIdiom == .phone ? (cellWidth * 3) / 2 : (cellWidth * 3) / 4
        
        return CGSize(width: cellWidth, height: cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return minimumInterspace
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return collectionViewSectionInsets
    }
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
        
        productsCollectionView?.accessibilityIdentifier = AccessibilityIdentifiers.productsCollectionView.rawValue
        productsCollectionView?.isAccessibilityElement = false
    }
}


