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
        
        configureNib()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        configureNib()
    }
    
    /// Load and configure view Nib
    private func configureNib() {
        
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
            
            let adviesprijsText = "ADVERTISED_PRICE_TEXT".localized
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: "\(adviesprijsText) \(listPrice)")
            
            /// Cross out the old price text
            let separatorRange = attributeString.mutableString.range(of: " ")
            attributeString.addAttribute(.strikethroughStyle, value: 1, range: NSMakeRange(separatorRange.upperBound, "\(listPrice)".count))

            listPriceLabel.attributedText = attributeString
        }
    }

}
