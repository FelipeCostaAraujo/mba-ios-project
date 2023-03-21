//
//  Product+Various.swift
//  ComprasUSA
//
//  Created by Felipe C. Araujo on 20/03/23.
//

import UIKit

extension Product {
    var priceFormatted: String {
        "\(value)"
    }
    
    var poster: UIImage? {
        if let data = image {
            return UIImage(data: data)
        } else {
            return nil
        }
    }
}
