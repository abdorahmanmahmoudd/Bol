//
//  ProductPriceView.swift
//  Bol
//
//  Created by Abdelrahman Ali on 20/12/2020.
//

import UIKit

final class ProductPriceView: UIView {

    // UI Outlets
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var listPriceLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        guard let xibView = loadNib() else {
            return
        }

        addSubview(xibView)
        xibView.activateConstraints(for: self)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        guard let xibView = loadNib() else {
            return
        }

        addSubview(xibView)
        xibView.activateConstraints(for: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        listPriceLabel.text = nil
        priceLabel.text = nil
    }
    
    // Configure view with data
    func configure(with price: Float, listPrice: Float?) {
        
        priceLabel.text = "\(price)"
        
        if let listPrice = listPrice {
            listPriceLabel.text = "adviesprijs \(listPrice)"
        }
    }

}
