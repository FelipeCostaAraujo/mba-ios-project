//
//  MovieFormViewController.swift
//  ComprasUSA
//
//  Created by Felipe C. Araujo on 06/12/22.
//

import UIKit
import CoreData

final class MovieFormViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var textFieldTitle: UITextField!
    @IBOutlet weak var textFieldRating: UITextField!
    @IBOutlet weak var textFieldDuration: UITextField!
    @IBOutlet weak var labelCategories: UILabel!
    @IBOutlet weak var imageViewPoster: UIImageView!
    @IBOutlet weak var textViewSummary: UITextView!
    @IBOutlet weak var buttonSave: UIButton!
    
    // MARK: - Properties
    var movie: Movie?
    var selectedCategories: Set<Category> = [] {
        didSet {
            if selectedCategories.isEmpty {
                labelCategories.text = "Adicionar categorias"
            } else {
                labelCategories.text = selectedCategories.compactMap{$0.name}.sorted().joined(separator: " | ")
            }
        }
    }
    
    // MARK: - Super Method
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let categoriesViewController = segue.destination as? CategoriesTableViewController
        categoriesViewController?.selectedCategories = selectedCategories
        categoriesViewController?.delegate = self
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: - Method
    private func setupUI() {
        if let movie = movie {
            title = "Atualização de Filme"
            textFieldTitle.text = movie.title
            textFieldRating.text = "\(movie.rating)"
            textFieldDuration.text = movie.duration
            textViewSummary.text = movie.summary
//            labelCategories.text = ""
            imageViewPoster.image = movie.poster
            buttonSave.setTitle("Atualizar", for: .normal)
            if let categories = movie.categories as? Set<Category> {
                selectedCategories = categories
            }
        }
    }
    
    private func selectPictureFrom(_ sourceType: UIImagePickerController.SourceType) {
        view.endEditing(true)
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = sourceType
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    // MARK: - IBActions
    @IBAction func selectImage(_ sender: UIButton) {
        let alert = UIAlertController(title: "Selecionar pôster", message: "De onde você deseja escolher o pôster?", preferredStyle: .actionSheet)
                
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Câmera", style: .default) { _ in
                self.selectPictureFrom(.camera)
            }
            alert.addAction(cameraAction)
        }
        
        let libraryAction = UIAlertAction(title: "Biblioteca de Fotos", style: .default) { _ in
            self.selectPictureFrom(.photoLibrary)
        }
        alert.addAction(libraryAction)
        
        let photosAction = UIAlertAction(title: "Álbum de Fotos", style: .default) { _ in
            self.selectPictureFrom(.savedPhotosAlbum)
        }
        alert.addAction(photosAction)
        
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: UIButton) {
        if movie == nil {
            movie = Movie(context: context)
        }
        
        movie?.title = textFieldTitle.text
        movie?.duration = textFieldDuration.text
        movie?.summary = textViewSummary.text
        movie?.rating = Double(textFieldRating.text ?? "") ?? 0
        movie?.image = imageViewPoster.image?.jpegData(compressionQuality: 0.8)
        movie?.categories = selectedCategories as NSSet
        
        do {
            try context.save()
            navigationController?.popViewController(animated: true)
        } catch {
            print(error)
        }
        
    }
    
}

extension MovieFormViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            imageViewPoster.image = image
        }
        
        dismiss(animated: true, completion: nil)
    }
}


extension MovieFormViewController: CategoriesDelegate {
    func setSelectedCategories(_ categories: Set<Category>) {
        selectedCategories = categories
    }
}
