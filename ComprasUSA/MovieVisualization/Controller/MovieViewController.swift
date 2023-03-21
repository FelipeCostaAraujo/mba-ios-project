//
//  MovieViewController.swift
//  ComprasUSA
//
//  Created by Felipe C. Araujo on 08/11/22.
//

import UIKit
import AVKit

final class MovieViewController: UIViewController {

    // TOC: Trabalhar Organização Código
    
    // MARK: - IBOutlets
    @IBOutlet weak var imageViewPoster: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelCategories: UILabel!
    @IBOutlet weak var labelDuration: UILabel!
    @IBOutlet weak var labelRating: UILabel!
    @IBOutlet weak var textViewSummary: UITextView!
    
    // MARK: - Properties
    var movie: Movie?
    private var trailer: String = ""
    private var moviePlayer: AVPlayer?
    private var moviePlayerController: AVPlayerViewController?
    
    // MARK: - Super Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupUI()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let movieFormViewController = segue.destination as? MovieFormViewController {
            movieFormViewController.movie = movie
        }
    }
    
    // MARK: - Methods
    private func setupUI() {
        if let movie = movie {
            imageViewPoster.image = movie.poster
            labelTitle.text = movie.title
            labelRating.text = movie.ratingFormatted
            labelDuration.text = movie.duration
            textViewSummary.text = movie.summary
            if let categories = movie.categories as? Set<Category> {
                labelCategories.text = categories.compactMap{$0.name}.sorted().joined(separator: " | ")
            } else {
                labelCategories.text = nil
            }
            if let title = movie.title, !title.isEmpty {
                loadTrailer(with: title)
            }
        }
    }
    
    private func loadTrailer(with title: String) {
        let itunesPath = "https://itunes.apple.com/search?media=movie&entity=movie&term="

        guard let encodedTitle = title.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed),
              let url = URL(string: "\(itunesPath)\(encodedTitle)") else {return}

        URLSession.shared.dataTask(with: url) { (data, _, _) in
            guard let data = data else {return}
            let apiResult = try! JSONDecoder().decode(ItunesResult.self, from: data)
            self.trailer = apiResult.results.first?.previewUrl ?? ""
            DispatchQueue.main.sync {
                self.prepareVideo()
            }
        }.resume()
    }
    
    private func prepareVideo() {
        guard let url = URL(string: trailer) else { return }
        moviePlayer = AVPlayer(url: url)
        moviePlayerController = AVPlayerViewController()
        moviePlayerController?.player = moviePlayer
    }

    // MARK: - IBActions
    @IBAction func play(_ sender: UIButton) {
        guard let moviePlayerController = moviePlayerController else { return }
        present(moviePlayerController, animated: true) {
            self.moviePlayer?.play()
        }
    }
}

