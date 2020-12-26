//
//  ProductsCarouselCollectionViewCell.swift
//  Bol
//
//  Created by Abdelrahman Ali on 25/12/2020.
//

import UIKit
import Nuke

final class ProductsCarouselCollectionViewCell: UICollectionViewCell {

    // UIOutlets
    @IBOutlet private weak var productPriceView: ProductPriceView!
    @IBOutlet private weak var productNameLabel: UILabel!
    @IBOutlet private weak var productSellerLabel: UILabel!
    @IBOutlet private weak var productImageView: UIImageView!
    @IBOutlet private weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        resetViews()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        containerView.layer.shadow(shadow: .cardShadow)
        
        /// For Rendering optimization
        /// Only use this when you are not doing any animations within the view componenets, otherwise it will have bad performance implications.
        containerView.layer.shouldRasterize = true
        containerView.layer.rasterizationScale = UIScreen.main.scale
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        resetViews()
    }
    
    private func resetViews() {
        productImageView.image = nil
        productSellerLabel.text = nil
        productNameLabel.text = nil
        productPriceView.configure(with: 0, listPrice: nil)
    }
    
    func configure(_ product: Product) {
        
        /// Setup product price view
        if let price = product.offerData?.offers?.first?.price {
            let listPrice = product.offerData?.offers?.first?.listPrice
            productPriceView.configure(with: price, listPrice: listPrice)
        }
        
        productNameLabel.text = product.title
        productSellerLabel.text = product.specsTag
        
        if let urlString = product.media?.first?.url, let imageURL = URL(string: urlString) {
            Nuke.loadImage(with: imageURL, into: productImageView)
        } else {
            productImageView.image = #imageLiteral(resourceName: "image-placeholder")
        }
    }

}
