//
//  ViewController.swift
//  Todeuy
//
//  Created by 송하민 on 2021/08/04.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {

    var todoItems: Results<Item>?
    let realm = try! Realm()
    
    var selectedCategory: Category? {
        didSet {
            loadItems()
        }
    }
    
    override func viewDidLoad() {
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        super.viewDidLoad()
        
        self.rightbarButton.action = #selector(addButtonPressed)
        self.rightbarButton.target = self
        self.navigationItem.rightBarButtonItem = rightbarButton
    }
    
    let rightbarButton:UIBarButtonItem = {
        let barButton = UIBarButtonItem(systemItem: .add)
        barButton.tintColor = UIColor.white
        return barButton
    }()
    
    @objc func addButtonPressed() {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { [weak self] (action) in
            guard let fieldText = textField.text else {
                return
            }
            
            if let category = self?.selectedCategory {
                do{
                    try self?.realm.write {
                        let item = Item()
                        item.title = fieldText
                        item.done = false
                        item.createdDate = Date()
                        category.items.append(item)
                    }
                } catch {
                    print(error)
                }
            }
            self?.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: Model Manuplation Methods
    
    func loadItems() {

        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)

        tableView.reloadData()
    }
}

extension TodoListViewController {
    // MARK: TableView DataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItemCell", for: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done == true ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No Items Added"
        }
        
        return cell
    }
}

extension TodoListViewController {
    // MARK: TableView Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
//                    realm.delete(item)
                    item.done.toggle()
                }
            } catch {
                print(error)
            }
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}
extension TodoListViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "createdDate", ascending: false)
        
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
//            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}


