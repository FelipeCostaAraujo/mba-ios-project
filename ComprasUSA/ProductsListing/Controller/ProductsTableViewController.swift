//
//  ProductsTableViewController.swift
//  ComprasUSA
//
//  Created by Felipe C. Araujo on 20/03/2023.
//

import UIKit
import CoreData

final class ProductsTableViewController: UITableViewController {
    
    private let label: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "Sua lista está vazia!"
        label.textAlignment = .center
        return label
    }()
    
    private lazy var fetchedResultsController: NSFetchedResultsController<Product> = {
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.singleLine
        loadProducts()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let productViewController = segue.destination as? ProductViewController,
           let indexPath = tableView.indexPathForSelectedRow {
            productViewController.product = fetchedResultsController.object(at: indexPath)
        }
    }


    func loadProducts() {
        do {
            try fetchedResultsController.performFetch()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rows = fetchedResultsController.fetchedObjects?.count ?? 0
        tableView.backgroundView = rows == 0 ? label : nil
        return rows
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? ProductTableViewCell else {
            return UITableViewCell()
        }

        let movie = fetchedResultsController.object(at: indexPath)
        cell.configure(with: movie)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let product = fetchedResultsController.object(at: indexPath)
            context.delete(product)
            try? context.save()
        }
    }

}

// MARK: - NSFetchedResultsControllerDelegate
extension ProductsTableViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.reloadData()
    }
}
