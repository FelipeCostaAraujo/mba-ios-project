//
//  ProductTableViewCell.swift
//  ComprasUSA
//
//  Created by Felipe C. Araujo on 20/03/2023.
//

import UIKit

final class ProductTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var imageViewPoster: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbPrice: UILabel!
    @IBOutlet weak var lbStates: UILabel!
    @IBOutlet weak var paymentMethod: UILabel!
    
    override func prepareForReuse() {
        lbName.text = nil
        lbPrice.text = nil
        lbStates.text = nil
        paymentMethod.text = nil
        imageViewPoster.image = nil
        imageViewPoster.layer.cornerRadius = 8
    }
    
    func configure(with product: Product) {
        lbName.text = product.name
        lbPrice.attributedText = NSMutableAttributedString()
            .bold(product.priceFormattedUSA)
        if(product.card){
            paymentMethod.attributedText = NSMutableAttributedString()
                .bold("Forma de pagamento: ")
                .normal("Cartão")
        }else{
            paymentMethod.attributedText = NSMutableAttributedString()
                .bold("Forma de pagamento: ")
                .normal("Dinheiro")
        }
        
        lbStates.attributedText = NSMutableAttributedString()
            .bold("Estado: ")
            .normal(product.states?.name ?? "")
        imageViewPoster.image = product.poster
        imageViewPoster.layer.cornerRadius = 8
    }
    
}

extension NSMutableAttributedString {
    var fontSize:CGFloat { return 14 }
    var boldFont:UIFont { return UIFont(name: "AvenirNext-Bold", size: fontSize) ?? UIFont.boldSystemFont(ofSize: fontSize)}
    var normalFont:UIFont { return UIFont(name: "AvenirNext-Regular", size: fontSize) ?? UIFont.systemFont(ofSize: fontSize)}
    
    func bold(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font : boldFont
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
    
    func normal(_ value:String) -> NSMutableAttributedString {
        
        let attributes:[NSAttributedString.Key : Any] = [
            .font : normalFont,
        ]
        
        self.append(NSAttributedString(string: value, attributes:attributes))
        return self
    }
}
