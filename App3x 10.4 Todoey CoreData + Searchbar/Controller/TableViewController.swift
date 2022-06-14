//
//  ViewController.swift
//  App3x 10.1 Todoey
//
//  Created by Marwan Elbahnasawy on 04/06/2022.
//

import UIKit

class TableViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var itemEntity = [Item]()

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        loadItems()
    }

    @IBAction func addPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Todoey", message: "Add a new memo", preferredStyle: .alert)
        var alertTextField = UITextField()
        let alertAction = UIAlertAction(title: "Add", style: .default) { action in
            if let safeAlertTextFieldText = alertTextField.text {
                
                let newItem = Item(context: self.context)
                newItem.titleItem = safeAlertTextFieldText
                newItem.doneItem = false
                newItem.dateItem = Date().timeIntervalSince1970
                
                self.itemEntity.append(newItem)
                self.saveItems()
            }
            
        }
        alert.addAction(alertAction)
        alert.addTextField { textField in
            textField.placeholder = "Memo Title"
            alertTextField = textField
        }
        present(alert, animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemEntity.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        cell.textLabel?.text = itemEntity[indexPath.row].titleItem
        cell.accessoryType = itemEntity[indexPath.row].doneItem == true ? .checkmark : .none
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemEntity[indexPath.row].doneItem = !itemEntity[indexPath.row].doneItem
        saveItems()
    }
    
    
    
    func loadItems(){
        let request = Item.fetchRequest()
        do {
        itemEntity = try context.fetch(request)
    }
        catch {
            print("Error while trying to load Items ---> \(error)")
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func saveItems(){
        do {
        try context.save()
    }
        catch {
            print("Error while trying to save Items ---> \(error)")
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}

extension TableViewController : UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchBar.text == "" {
            loadItems()
        }
        else {
        var request = Item.fetchRequest()
        let predicate = NSPredicate(format: "titleItem CONTAINS [cd] %@", searchBar.text as! CVarArg)
        request.predicate = predicate
        do {
        itemEntity = try context.fetch(request)
    }
        catch {
            print("Error while trying to load Items ---> \(error)")
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}
}
