//
//  CategoryTableViewController.swift
//  Todeuy
//
//  Created by 송하민 on 2021/08/25.
//

import UIKit
import RealmSwift

class CategoryTableViewController: UITableViewController {
    
    let realm = try! Realm()
    
    var categoryArray: Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.title = "Toduey"
        rightButton.action = #selector(addCategory)
        rightButton.target = self
        self.navigationItem.rightBarButtonItem = rightButton
        loadCategories()
    }
    
    let rightButton:UIBarButtonItem = {
        let button = UIBarButtonItem(systemItem: .add)
        button.tintColor = .white
        return button
    }()

    @objc private func addCategory() {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Category"
            textField = alertTextField
        }
        let action = UIAlertAction(title: "Add Category", style: .default) { action in
            guard let fieldText = textField.text else {
                return
            }
            let newCategory = Category()
            newCategory.name = fieldText
            
            self.save(category: newCategory)
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    private func save(category: Category) {
        do {
            try realm.write({
                realm.add(category)
            })
            loadCategories()
        } catch {
            print("Error saving context \(error)")
        }
    }
    
    private func loadCategories() {
        categoryArray = realm.objects(Category.self)
        
        tableView.reloadData()
    }
    
    
    // MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray?.count ?? 1
    }
    
    // MARK: - TableView Datasource Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }
    
    
    // MARK: - Data Manipulation Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        let category = categoryArray?[indexPath.row]
        cell.textLabel?.text = category?.name ?? "No Category added yet"
        return cell
    }
    
}
