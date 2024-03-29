//
//  SettingsViewController.swift
//  ComprasUSA
//
//  Created by Felipe C. Araujo on 08/12/22.
//

import UIKit
import CoreData

enum CategoryType {
    case add
    case edit
}

final class SettingsViewController: UIViewController {
    
    private let label: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "Lista de estados vazia."
        label.textAlignment = .center
        return label
    }()

    // MARK: - IBOutlets
    @IBOutlet weak var textFieldExchange: UITextField!
    @IBOutlet weak var textFieldIOF: UITextField!
    @IBOutlet weak var statesTableView: UITableView!
    
    
    // MARK: - Properties
    var states: [State] = []
    var product: Product?
    private let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        statesTableView.delegate = self
        statesTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textFieldExchange.text = userDefaults.string(forKey: "exchange")  ?? "3.2"
        textFieldIOF.text = userDefaults.string(forKey: "iof")  ?? "6.38"
        loadStates()
    }
    
    @IBAction func editExchange(_ sender: Any) {
        
        if (textFieldExchange.text?.isEmpty)! {
            alertWithTitle(title: "Erro", message: "Digite uma cotação.", ViewController: self, toFocus:textFieldExchange)
            return
        } else {
            userDefaults.set(textFieldExchange.text, forKey: "exchange")
        }
    }
   
    @IBAction func editIOF(_ sender: Any) {
        
        if (textFieldIOF.text?.isEmpty)! {
            alertWithTitle(title: "Erro", message: "Digite o IOF.", ViewController: self, toFocus:textFieldIOF)
            return
        } else {
            userDefaults.set(textFieldIOF.text, forKey: "iof")
        }
        
    }
    
    // MARK: - Methods
    func loadStates() {
        let fetchRequest: NSFetchRequest<State> = State.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            states = try context.fetch(fetchRequest)
            statesTableView.reloadData()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func showAlert(type: CategoryType, state: State?) {
        let title = (type == .add) ? "Adicionar" : "Editar"
        let alert = UIAlertController(title: "\(title) Estado", message: nil, preferredStyle: .alert)
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = "Nome da estado"
            if let name = state?.name {
                textField.text = name
            }
        }
        
        alert.addTextField { (textField: UITextField) in
            textField.placeholder = "Taxa do estado"
            textField.keyboardType = .decimalPad
            if let tax = state?.tax {
                textField.text = "\(tax)"
            }
        }
        
        alert.addAction(UIAlertAction(title: title, style: .default, handler: { (action: UIAlertAction) in
            
            if ((alert.textFields?.first?.text?.isEmpty)! || (alert.textFields?.last?.text?.isEmpty)!){
                self.alertWithTitle(title: "Erro", message: "Erro ao adicionar o estado", ViewController: self, toFocus: self.textFieldIOF)
                return
            }
            else {
                let state = state ?? State(context: self.context)
                state.name = alert.textFields?.first?.text
                state.tax = Double((alert.textFields?.last?.text) ?? "0") ?? 0
                do {
                    try self.context.save()
                    self.loadStates()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    // MARK: - IBActions
    @IBAction func add(_ sender: Any) {
        showAlert(type: .add, state: nil)
    }
    
    func alertWithTitle(title: String!, message: String, ViewController: UIViewController, toFocus:UITextField) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel,handler: {_ in
            toFocus.becomeFirstResponder()
        });
        alert.addAction(action)
        ViewController.present(alert, animated: true, completion:nil)
    }
}

// MARK: - UITableViewDelegate
extension SettingsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Excluir") { action, view, completionHandler in
            let state = self.states[indexPath.row]
            self.context.delete(state)
            try? self.context.save()
            
            self.states.remove(at: indexPath.row)
            self.statesTableView.deleteRows(at: [indexPath], with: .automatic)
            
            completionHandler(true)
        }
        
        deleteAction.image = UIImage(systemName: "trash")
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}

// MARK: - UITableViewDelegate
extension SettingsViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rows = states.count
        tableView.backgroundView = rows == 0 ? label : nil
        return rows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let state = states[indexPath.row]
        cell.textLabel?.text = state.name
        cell.detailTextLabel?.text = "\(state.tax)"
        cell.accessoryType = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showAlert(type: .edit, state: states[indexPath.row])
    }

}

// MARK: - NSFetchedResultsControllerDelegate
extension SettingsViewController: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        loadStates()
    }
}
