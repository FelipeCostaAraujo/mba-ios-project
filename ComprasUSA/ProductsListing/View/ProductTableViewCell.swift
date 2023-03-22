//
//  ProductTableViewCell.swift
//  ComprasUSA
//
//  Created by Felipe C. Araujo on 20/03/2023.
//

import UIKit

class ProductTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var imageViewPoster: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var lbStates: UILabel!
    
    override func prepareForReuse() {
        lbName.text = nil
        lbPrice.text = nil
        lbStates.text = nil
        imageViewPoster.image = nil
        imageViewPoster.layer.cornerRadius = 8
    }
    
    func configure(with product: Product) {
        lbName.text = product.name
        lbPrice.text = product.priceFormatted
        lbStates.text = product.states?.name
        imageViewPoster.image = product.poster
        imageViewPoster.layer.cornerRadius = 8
    }
    
}
