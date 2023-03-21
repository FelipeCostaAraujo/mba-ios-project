//
//  MovieTableViewCell.swift
//  ComprasUSA
//
//  Created by Felipe C. Araujo on 17/11/22.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var imageViewPoster: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelSummary: UILabel!
    @IBOutlet weak var labelRating: UILabel!
    
    override func prepareForReuse() {
        labelTitle.text = nil
        labelRating.text = nil
        labelSummary.text = nil
        imageViewPoster.image = nil
        imageViewPoster.layer.cornerRadius = 8
    }
    
    func configure(with movie: Movie) {
        labelTitle.text = movie.title
        labelRating.text = movie.ratingFormatted
        labelSummary.text = movie.summary
        imageViewPoster.image = movie.poster
        imageViewPoster.layer.cornerRadius = 8
    }

}
