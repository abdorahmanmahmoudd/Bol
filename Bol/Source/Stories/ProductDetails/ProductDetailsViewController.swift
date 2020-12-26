//
//  ProductDetailsViewController.swift
//  Bol
//
//  Created by Abdelrahman Ali on 20/12/2020.
//

import UIKit
import RxSwift
import Cosmos

final class ProductDetailsViewController: BaseViewController {
    
    /// UI Outlets
    @IBOutlet private weak var productImagesCollectionView: UICollectionView!
    @IBOutlet private weak var imagesPageControlView: PageControlView!
    
    @IBOutlet private weak var productNameLabel: UILabel!
    @IBOutlet private weak var productSellerLabel: UILabel!
    @IBOutlet private weak var productPriceView: ProductPriceView!
    
    @IBOutlet private weak var ratingView: CosmosView!
    @IBOutlet private weak var productAvailabilityView: ProductAvailabilityView!
    
    @IBOutlet private weak var accessoriesCarouselView: ProductsCarouselView!
    
    /// `ProductDetailsViewModel`
    private var viewModel: ProductDetailsViewModel!
    
    /// RxSwift
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        /// Configure Product images collectionView
        configureProductImagesCollectionView()
        
        /// Fetch Product Details API call
        viewModel.fetchProductDetails()
        
        /// Fetch Product accessories API call
        viewModel.fetchProductAccessories()
        
        /// Bind observables
        bindObservables()
        
        /// Configure navigationBar
        styleNavigationBar()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        /// If poping from parent view controller, notify the parent coordinator.
        if isMovingFromParent {
            (coordinator as? ProductDetailsCoordinator)?.didFinish()
        }
    }
    
    private func styleNavigationBar() {
        navigationController?.hidesBarsOnSwipe = false
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    /// Product images collection view configuration
    private func configureProductImagesCollectionView() {
        
        productImagesCollectionView.dataSource = self
        productImagesCollectionView.delegate = self
        
        let productImageNib = UINib(nibName: ProductImageCollectionViewCell.identifier, bundle: nil)
        productImagesCollectionView.register(productImageNib, forCellWithReuseIdentifier: ProductImageCollectionViewCell.identifier)
    }
    
    private func configureImagesPageControl() {
        imagesPageControlView.pages = viewModel.productMedia()
    }
    
    private func bindObservables() {
        
        /// Set view model state change callback
        viewModel.refreshState = { [weak self] in
            
            guard let self = self else {
                return
            }
            
            switch self.viewModel.state {
            
            case .initial:
                debugPrint("initial ProductDetailsViewController")
                
            case .loading:
                debugPrint("loading ProductDetailsViewController")
                self.showLoadingIndicator(visible: true)
                
                
            case .error(let error):
                self.handleError(error)
                
            case .result:
                debugPrint("Result ProductDetailsViewController")
                self.showLoadingIndicator(visible: false)
                
                /// If there is no results then show a message with a try again button
                if self.viewModel.isEmpty() {
                    
                    self.showError(with: "GENERAL_EMPTY_STATE_ERROR".localized, retry: {
                        self.viewModel.fetchProductDetails()
                    })
                    return
                }
                self.removeErrorView()
                self.configureViews()
            }
        }

        /// Configure accessories view to listen for accessories behavior updates
        viewModel.accessories.asDriver(onErrorJustReturn: [])
            .drive(onNext: { [weak self] products in

            self?.accessoriesCarouselView.configure(products)
            
        }).disposed(by: disposeBag)
    }
    
    /// Retry block if counters an error.
    override func retry() {
        self.viewModel.fetchProductDetails()
    }

    /// Reload views with data
    private func configureViews() {
        
        /// Setup product images
        configureImagesPageControl()
        productImagesCollectionView.reloadData()
        
        /// Setup product name and seller
        productNameLabel.text = viewModel.product?.title
        productSellerLabel.text = viewModel.product?.specsTag
        
        /// Setup product price view
        if let price = viewModel.product?.offerData?.offers?.first?.price {
            let listPrice = viewModel.product?.offerData?.offers?.first?.listPrice
            productPriceView.configure(with: price, listPrice: listPrice)
        }
        
        /// Setup product rating view
        ratingView.rating = Double(viewModel.product?.rating ?? 0) / 10
        
        /// Setup product availability view
        if let availability = viewModel.product?.offerData?.offers?.first?.availabilityDescription {
            productAvailabilityView.configure(with: availability)
        }
    }
}

// MARK: UICollectionViewDataSource
extension ProductDetailsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.productMedia()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductImageCollectionViewCell.identifier, for: indexPath) as? ProductImageCollectionViewCell else {
            fatalError("Couldn't dequeue cell \(ProductImageCollectionViewCell.description())")
        }
        
        cell.configure(with: viewModel.mediaURL(of: indexPath.item))
        
        return cell
    }
}

// MARK: UICollectionViewDelegate
extension ProductDetailsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        debugPrint("Selected \(indexPath)")
    }
    
    /// Updating the PageControl current page
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

        let pageWidth = Float(cellSize().width)
        let currentOffset: Float = Float(scrollView.contentOffset.x)
        let targetOffset: Float = Float(targetContentOffset.pointee.x)
        var newTargetOffset: Float = 0

        /// to determine wether we are scrolling to the next or the previous item
        if targetOffset > currentOffset {
            /// next item offset
            newTargetOffset = ceilf(currentOffset / pageWidth) * pageWidth
        } else {
            /// previous item offset
            newTargetOffset = floorf(currentOffset / pageWidth) * pageWidth
        }

        /// to handle scroll before first item
        if newTargetOffset < 0 {
            newTargetOffset = 0

        } else if newTargetOffset > Float(scrollView.contentSize.width) { /// to handle scroll after last item
            newTargetOffset = Float(scrollView.contentSize.width)
        }

        /// calculate new target index
        let newTargetIndex = Int(newTargetOffset / pageWidth)

        /// Update page control with the new index
        imagesPageControlView.currentPage = newTargetIndex
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension ProductDetailsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize()
    }
    
    private func cellSize() -> CGSize {
        return CGSize(width: view.frame.width, height: 300.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}


// MARK: Injectable
extension ProductDetailsViewController: Injectable {

    typealias Payload = ProductDetailsViewModel

    func inject(payload: ProductDetailsViewModel) {
        viewModel = payload
    }

    func assertInjection() {
        assert(viewModel != nil)
    }
}

// MARK: Accessibility
extension ProductDetailsViewController {

    override func setAccessibilityIdentifiers(){
        super.setAccessibilityIdentifiers()
        
        productImagesCollectionView.accessibilityIdentifier = AccessibilityIdentifiers.productDetailsImagesCollectionView.rawValue
        imagesPageControlView.accessibilityIdentifier = AccessibilityIdentifiers.productDetailsImagesPageControl.rawValue
        productNameLabel.accessibilityIdentifier = AccessibilityIdentifiers.productDetailsProductName.rawValue
        productSellerLabel.accessibilityIdentifier = AccessibilityIdentifiers.productDetailsSeller.rawValue
        productPriceView.accessibilityIdentifier = AccessibilityIdentifiers.productDetailsPriceView.rawValue
        ratingView.accessibilityIdentifier = AccessibilityIdentifiers.productDetailsRatingView.rawValue
        productAvailabilityView.accessibilityIdentifier = AccessibilityIdentifiers.productDetailsAvailibilityView.rawValue
        accessoriesCarouselView.accessibilityIdentifier = AccessibilityIdentifiers.accessoriesCarouselView.rawValue
    }
}
