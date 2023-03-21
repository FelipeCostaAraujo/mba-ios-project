//
//  TotalViewController.swift
//  ComprasUSA
//
//  Created by Felipe C. Araujo on 21/03/23.
//

import UIKit
import CoreData

class TotalViewController: UIViewController {

    @IBOutlet weak var textFieldDollar: UILabel!
    @IBOutlet weak var textFieldReal: UILabel!
    
    private lazy var fetchedResultsController: NSFetchedResultsController<Product> = {
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        return fetchedResultsController
    }()
    
    var products: [Product] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadProducts()
    }

    // MARK: - Methods
    func loadProducts() {
        do {
            try fetchedResultsController.performFetch()
            self.products = fetchedResultsController.fetchedObjects!
            calculate()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func calculate(){
        let exchangeTax = Double(UserDefaults.standard.string(forKey: "exchange") ?? "0")!
        let iofTax = Double(UserDefaults.standard.string(forKey: "iof") ?? "0")!
        
        var dolars = 0.0
        var reais = 0.0
        
        for product in products {
            dolars += product.value
            reais += product.value * exchangeTax
            
            if product.card {
                reais += (product.value * iofTax) / 100
            }
            reais += (product.value * (product.states!.tax)) / 100
        }
        
        textFieldDollar.text = String(format: "%.2f", dolars)
        textFieldReal.text = String(format: "%.2f", reais)
    }

}
