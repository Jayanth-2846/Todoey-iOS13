//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Jayanth Ambaldhage on 14/04/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
class CategoryViewController: UITableViewController {
    
    let realm = try! Realm()
    var categories: Results<Category>?
//    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        cell.textLabel?.text =  categories?[indexPath.row].name ?? "No categories added yet"
//        cell.textLabel?.text = item.name
//        value = condition ? valueifTrue: valueifFalse
        return cell
    }
    
    //MARK: - Add new categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let newCategory = Category()
            newCategory.name = textField.text!
//            self.categories.append(newCategory)
            self.save(category: newCategory)
        }
        
        alert.addTextField {
            
            (alertTextField) in alertTextField.placeholder = "Add a new category"
            textField = alertTextField
            
        }
        alert.addAction(action)
        present(alert, animated: true,completion: nil)
    }
    
    
    //MARK: - Table view delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! TodoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
    }
    
    
    //MARK: - Data manipulation methods
    func save(category: Category) {
        
//        let encoder = PropertyListEncoder()
        do {
//            let data = try encoder.encode(self.todoItems)
//            try data.write(to: self.dataFilePath!)
//           try context.save()
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error encoding item array, \(error)")
            print("Error saving context, \(error)")
        }
//            self.defaults.set(self.todoItems, forKey: "TodoListArray")
        self.tableView.reloadData()
    }
    
    func loadCategories() {
        
         categories = realm.objects(Category.self)
//        with request : NSFetchRequest<Category> = Category.fetchRequest()
//        let request : NSFetchRequest<Item> = Item.fetchRequest()
//        do {
//            categories = try context.fetch(request)
//        } catch {
//            print("Error fetching data from context,\(error)")
//        }
//        tableView.reloadData()
    }

}
