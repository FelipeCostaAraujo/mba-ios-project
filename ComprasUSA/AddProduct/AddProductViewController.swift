//
//  AddProductViewController.swift
//  ComprasUSA
//
//  Created by Felipe C. Araujo on 19/03/23.
//

import UIKit

class AddProductViewController: UIViewController {

    @IBOutlet weak var dolarTextField: UITextField!
    @IBOutlet weak var iofTextField: UITextField!
    @IBOutlet weak var ibTableView: UITableView!
    
    // MARK: - Properties
    var dataSource: [State] = []
    var product: Product!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        ibTableView.delegate = self
        ibTableView.dataSource = self
        loadStates()
    }
    
    // MARK: - Methods
    func loadStates() {
        let fetchRequest: NSFetchRequest<State> = State.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        do {
            dataSource = try context.fetch(fetchRequest)
            tableView.reloadData()
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
                self.alertWithTitle(title: "Erro", message: "Erro ao adicionar o estado", ViewController: self, toFocus: self.tfIOF)
                return
            }
            else {
                let state = state ?? State(context: self.context)
                state.name = alert.textFields?.first?.text
                state.tax = Double((alert.textFields?.last?.text)!)!
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
    
    private let label: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "Lista de estados vazia."
        label.textAlignment = .center
        label.font = label.font.withSize(20)
        label.textColor = UIColor.gray
        return label
    }()
    
    @IBAction func addState(_ sender: Any) {
        print("add state")
        print(dolarTextField.text)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}


// MARK: - UITableViewDelegate
extension AddProductViewController: UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Excluir") { (action: UITableViewRowAction, indexPath: IndexPath) in
            let state = self.dataSource[indexPath.row]
            self.context.delete(state)
            try! self.context.save()
            self.dataSource.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        let editAction = UITableViewRowAction(style: .normal, title: "Editar") { (action: UITableViewRowAction, indexPath: IndexPath) in
            let state = self.dataSource[indexPath.row]
            tableView.setEditing(false, animated: true)
            self.showAlert(type: .edit, state: state)
        }
        editAction.backgroundColor = .blue
        return [editAction, deleteAction]
    }
}

// MARK: - UITableViewDelegate
extension SettingsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let state = dataSource[indexPath.row]
        cell.textLabel?.text = state.name
        cell.detailTextLabel?.text = "\(state.tax)"
        cell.accessoryType = .none
      
        return cell
    }

}


