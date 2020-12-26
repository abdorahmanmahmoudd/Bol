//
//  ProductsCarouselView.swift
//  Bol
//
//  Created by Abdelrahman Ali on 25/12/2020.
//

import UIKit

protocol ProductsCarouselViewDelegate: class {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath, withProductId productId: String)
}

final class ProductsCarouselView: UIView {

    // UIOutlets
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var collectionViewHeightConstraint: NSLayoutConstraint!
    
    /// datasource
    private var products: [Product] = []
    
    /// CollectionView insets
    private let sectionInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    private let cellHeight: CGFloat = 290
    
    weak var delegate: ProductsCarouselViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        configureNib()
    }
    
    /// Load and configure Nib
    private func configureNib() {
        
        guard let xibView = loadNib() else {
            return
        }
        
        addSubview(xibView)
        xibView.activateConstraints(for: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureCollectionView()
    }
    
    private func configureCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        let carouselItemNib = UINib(nibName: ProductsCarouselCollectionViewCell.identifier, bundle: nil)
        collectionView.register(carouselItemNib, forCellWithReuseIdentifier: ProductsCarouselCollectionViewCell.identifier)
    }
    
    func configure(_ products: [Product]) {
        self.products = products
        collectionView.reloadData()
        layout()
    }
    
    /// Layout subviews
    private func layout() {
        collectionViewHeightConstraint.constant = products.isEmpty ? 0 : cellHeight + sectionInsets.top + sectionInsets.bottom
    }
}

// MARK: UICollectionViewDataSource
extension ProductsCarouselView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return products.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductsCarouselCollectionViewCell.identifier, for: indexPath) as? ProductsCarouselCollectionViewCell else {
            
            fatalError("Couldn't dequeue cell \(ProductsCarouselCollectionViewCell.description())")
        }
        
        cell.configure(products[indexPath.item])

        return cell
    }
}

// MARK: UICollectionViewDelegate
extension ProductsCarouselView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.collectionView(collectionView, didSelectItemAt: indexPath, withProductId: products[indexPath.item].id)
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension ProductsCarouselView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return cellSize()
    }
    
    private func cellSize() -> CGSize {
        let width: CGFloat = (UIScreen.main.bounds.width - (sectionInsets.left + sectionInsets.right)) / 2.5
        return CGSize(width: width, height: cellHeight)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
}
