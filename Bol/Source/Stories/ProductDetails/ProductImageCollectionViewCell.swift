//
//  ProductImageCollectionViewCell.swift
//  Bol
//
//  Created by Abdelrahman Ali on 20/12/2020.
//

import UIKit
import Nuke

final class ProductImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet private weak var productImageView: UIImageView!
    
    func configure(with imageURLString: String?) {
        
        if let urlString = imageURLString, let imageURL = URL(string: urlString) {
            Nuke.loadImage(with: imageURL, into: productImageView)
        } else {
            productImageView.image = #imageLiteral(resourceName: "image-placeholder")
        }
    }

}
