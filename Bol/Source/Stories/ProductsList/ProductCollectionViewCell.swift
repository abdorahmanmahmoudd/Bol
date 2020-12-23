//
//  ProductCollectionViewCell.swift
//  Bol
//
//  Created by Abdelrahman Ali on 20/12/2020.
//

import UIKit
import Nuke

final class ProductCollectionViewCell: UICollectionViewCell {

    /// UI Outlets
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var productImageView: UIImageView!
    @IBOutlet private weak var productTitle: UILabel!
    @IBOutlet private weak var productSellerLabel: UILabel!
    @IBOutlet private weak var productPrice: UILabel!
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        containerView.layer.shadow(shadow: .cardShadow)
        
        /// Only use this when you are not doing any animations within the view componenets, otherwise it will have bad performance implications,
        containerView.layer.shouldRasterize = true
        containerView.layer.rasterizationScale = UIScreen.main.scale
    }
    
    /// Fill the view data fields
    func configure(with product: Product) {
        
        productTitle.text = product.title
        productSellerLabel.text = product.offerData?.offers?.first?.seller?.displayName
        productPrice.text = "\(product.offerData?.offers?.first?.price ?? 0.0)"
        
        if let urlString = product.media?.first?.url, let imageURL = URL(string: urlString) {
            Nuke.loadImage(with: imageURL, into: productImageView)
        } else {
            productImageView.image = #imageLiteral(resourceName: "image-placeholder")
        }
    }

}
