//
//  ProductViewController.swift
//  ComprasUSA
//
//  Created by Felipe C. Araujo on 20/03/23.
//

import UIKit
import CoreData

final class ProductViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var textFieldTitle: UITextField!
    @IBOutlet weak var imageViewPoster: UIImageView!
    @IBOutlet weak var textFieldState: UITextField!
    @IBOutlet weak var textFieldValue: UITextField!
    @IBOutlet weak var switchCard: UISwitch!
    @IBOutlet weak var buttonSave: UIButton!
    
    // MARK: - Properties
    var product: Product?
    private var pickerView: UIPickerView!
    var states:[State] = []
    
    // MARK:  Super Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(addImage(tapGestureRecognizer:)))
        imageViewPoster.isUserInteractionEnabled = true
        imageViewPoster.addGestureRecognizer(tapGestureRecognizer)
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadStates()
        preparePickerView()
    }
    
    @objc func cancel() {
        textFieldState.resignFirstResponder()
    }
    
    @objc func done() {
        states.count > 0 ? textFieldState.text = states[pickerView.selectedRow(inComponent: 0)].name : nil
        cancel()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK:  Methods
    private func selectPictureFrom(_ sourceType: UIImagePickerController.SourceType) {
        view.endEditing(true)
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = sourceType
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    // MARK: - Method
    private func setupUI() {
        if let product = product {
            title = "Atualização do Produto"
            textFieldTitle.text = product.name
            textFieldValue.text = product.priceFormatted
            textFieldState.text = product.states?.name
            switchCard.setOn(product.card, animated: true)
            imageViewPoster.image = product.poster
            buttonSave.setTitle("Atualizar", for: .normal)
        }
    }
    
    func loadStates() {
        let fetchRequest: NSFetchRequest<State> = State.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            states = try context.fetch(fetchRequest)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func preparePickerView(){
        pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 44))
        let btSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let btDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        let btCancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        toolbar.items = [btCancel,btSpace,btDone]
        textFieldState.inputView = pickerView
        textFieldState.inputAccessoryView = toolbar
    }
    
    // MARK: - IBActions
    @IBAction func addImage(tapGestureRecognizer: UITapGestureRecognizer) {
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
    
    @IBAction func registerProduct(_ sender: Any) {
        guard let title = textFieldTitle.text else {
            return
        }
        
        if title.isEmpty {
            showAlert(title: "Erro", message: "Digite o nome do produto.", toFocus:textFieldTitle)
            return
        }
        
        guard let state = textFieldState.text else {
            return
        }
        
        if state.isEmpty {
            showAlert(title: "Erro", message: "Escolha um estado.", toFocus:textFieldState)
            return
        }
        
        guard let value = textFieldValue.text else {
            return
        }
        
        if value.isEmpty {
            showAlert(title: "Erro", message: "Digite um valor para o produto.", toFocus:textFieldValue)
            return
        }
        
        if product == nil {
            product = Product(context: context)
        }
        
        let formatter = NumberFormatter()
        formatter.decimalSeparator = ","
        let grade = formatter.number(from: textFieldValue.text ?? "")
        
        product?.states = states[pickerView.selectedRow(inComponent: 0)]
        product?.value = grade?.doubleValue ?? 0//Double(textFieldValue.text ?? "") ?? 0
        product?.name = textFieldTitle.text
        product?.card = switchCard.isOn
        product?.image = imageViewPoster.image?.jpegData(compressionQuality: 0.8)
        do {
            try context.save()
            navigationController?.popViewController(animated: true)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func showAlert(title: String, message: String,toFocus:UITextField) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel,handler: {_ in
            toFocus.becomeFirstResponder()
        });
        alert.addAction(action)
        present(alert, animated: true, completion:nil)
    }
    
}


// MARK: - UIImagePickerControllerDelegate
extension ProductViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[.originalImage] as? UIImage {
            imageViewPoster.image = image
        }
        
        dismiss(animated: true, completion: nil)
    }
}

extension ProductViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return states[row].name
    }
}

extension ProductViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return states.count
    }
}
