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
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    
    override func prepareForReuse() {
        labelName.text = nil
        labelPrice.text = nil
        imageViewPoster.image = nil
        imageViewPoster.layer.cornerRadius = 8
    }
    
    func configure(with product: Product) {
        labelName.text = product.name
        labelPrice.text = product.priceFormatted
        imageViewPoster.image = product.poster
        imageViewPoster.layer.cornerRadius = 8
    }
    
}
