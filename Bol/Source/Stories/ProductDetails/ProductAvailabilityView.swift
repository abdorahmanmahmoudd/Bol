//
//  ProductAvailabilityView.swift
//  Bol
//
//  Created by Abdelrahman Ali on 22/12/2020.
//

import UIKit

final class ProductAvailabilityView: UIView {

    @IBOutlet private weak var highlightedTextLabel: PaddingLabel!
    @IBOutlet private weak var selectLabel: UILabel!
    @IBOutlet private weak var detailsButton: UIButton!
    
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
        
        highlightedTextLabel.text = nil
        selectLabel.text = nil
        detailsButton.setTitle(nil, for: .normal)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        configureHighlightedTextLabel()
    }
    
    private func configureHighlightedTextLabel() {
        // TODO: Make meaningful names for these Static numbers.
        highlightedTextLabel.layer.borderWidth = 1.0
        highlightedTextLabel.layer.cornerRadius = 4
        highlightedTextLabel.layer.borderColor = UIColor.systemGreen.cgColor
        highlightedTextLabel.padding(4, 4, 6, 6)
    }
    
    /// Configure the view with the data based on the required design.
    func configure(with availabilityDescription: String) {
        
        var substrings = availabilityDescription.split(separator: ".")
        
        /// If there are more than 1 substrings, show the first one in a highlighted label design followed by "Select" text.
        if substrings.count > 1 {
            highlightedTextLabel.text = substrings.removeFirst().description
            selectLabel.text = "PRODUCT_AVAILABILITY_SELECT".localized
        }
        
        /// The remaining substring should be shown as normal details label with info, icon
        if substrings.count > 0 {
            detailsButton.setTitle(substrings.removeLast().description, for: .normal)
        } else {
            detailsButton.setImage(nil, for: .normal)
        }
    }
}
