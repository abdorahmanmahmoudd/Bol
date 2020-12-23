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
    
    
    /// `ProductDetailsViewModel`
    private var viewModel: ProductDetailsViewModel!
    
    /// RxSwift
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        /// Setup Product images collectionView
        setupProductImagesCollectionView()
        
        /// Fetch Product Details API call
        viewModel.fetchProductDetails()
        
        /// Bind observables
        bindObservables()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        /// If pop from parent view controller
        if isMovingFromParent {
            (coordinator as? ProductDetailsCoordinator)?.didFinish()
        }
    }
    
    private func setupProductImagesCollectionView() {
        
        productImagesCollectionView.dataSource = self
        productImagesCollectionView.delegate = self
        
        let productImageNib = UINib(nibName: ProductImageCollectionViewCell.identifier, bundle: nil)
        productImagesCollectionView.register(productImageNib, forCellWithReuseIdentifier: ProductImageCollectionViewCell.identifier)
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
                debugPrint("error \(String(describing: error))")
                self.showLoadingIndicator(visible: false)
                
                /// If there is an error then show error view with that error and try again button
                self.showError(with: "GENERAL_EMPTY_STATE_ERROR".localized, message: error?.localizedDescription, retry: {
                    self.viewModel.fetchProductDetails()
                })
                return
                
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
                self.refreshViews()
            }
        }
    }
    
    private func setupImagesPageControl() {
        imagesPageControlView.pages = viewModel.productMedia()
    }

    private func refreshViews() {
        
        /// Setup product images
        setupImagesPageControl()
        productImagesCollectionView.reloadData()
        
        /// Setup product name and seller
        productNameLabel.text = viewModel.product?.title ?? "n/a"
        productSellerLabel.text = viewModel.product?.offerData?.offers?.first?.seller?.displayName ?? "n/a"
        
        /// Setup product price view
        let price = viewModel.product?.offerData?.offers?.first?.price ?? 0.0
        let listPrice = viewModel.product?.offerData?.offers?.first?.listPrice
        productPriceView.configure(with: price, listPrice: listPrice)
        
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
    
    // Updating the PageControl current page
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
