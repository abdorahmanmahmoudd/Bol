//
//  ProductTableViewCell.swift
//  Bol
//
//  Created by Abdelrahman Ali on 20/12/2020.
//

import UIKit
import Nuke

final class ProductTableViewCell: UITableViewCell {

    /// UI Outlets
    @IBOutlet private weak var productImageView: UIImageView!
    @IBOutlet private weak var productTitle: UILabel!
    @IBOutlet private weak var productSellerLabel: UILabel!
    @IBOutlet private weak var productPrice: UILabel!
    
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
