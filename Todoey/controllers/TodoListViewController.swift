//
//  ViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 02/12/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import RealmSwift
class TodoListViewController: UITableViewController {
    
    var todoItems: Results<Item>?
    let realm = try! Realm()
    var selectedCategory : Category?
    {
        didSet{
            //             loadItems()
        }
    }
    //    let defaults = UserDefaults.standard
    
    //    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    //    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //    let searchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        //        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
        //            todoItems = items
        //        }
        //        navigationItem.searchController = searchController
        loadItems()
        
    }
    
    //MARK: - Tableview delegate methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return todoItems?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        if let item = todoItems?[indexPath.row]{
            cell.textLabel?.text = item.title
            //        value = condition ? valueifTrue: valueifFalse
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No items added"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row]{
            do {
                try realm.write {
                    item.done = !item.done
                }
            }catch {
                print("Error saving done status,\(error)")
            }
        }
        tableView.reloadData()
        //        context.delete(todoItems[indexPath.row])
        //        todoItems.remove(at: indexPath.row)
        
        //        todoItems[indexPath.row].done = !todoItems[indexPath.row].done
        //        self.saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    //MARK: - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Todoey item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write{
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error saving new items,\(error)")
                }
            }
            self.tableView.reloadData()
        }
        
        alert.addTextField {
            (alertTextField) in alertTextField.placeholder = "Create new item"
            textField = alertTextField
            
        }
        alert.addAction(action)
        present(alert, animated: true,completion: nil)
    }
    
    //MARK: - Model manipulating methods
    //
    //    func saveItems() {
    ////        let encoder = PropertyListEncoder()
    //        do {
    ////            let data = try encoder.encode(self.todoItems)
    ////            try data.write(to: self.dataFilePath!)
    //           try context.save()
    //        } catch {
    //            print("Error encoding item array, \(error)")
    //            print("Error saving context, \(error)")
    //        }
    ////            self.defaults.set(self.todoItems, forKey: "TodoListArray")
    //        self.tableView.reloadData()
    //    }
    //
    func loadItems(){
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title",ascending: true)
        tableView.reloadData()
        //        with request : NSFetchRequest<Item> = Item.fetchRequest(),predicate: NSPredicate? = nil
        ////        let request : NSFetchRequest<Item> = Item.fetchRequest()
        //        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        //
        //
        //        if let additionalPredicate = predicate {
        //            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        //        } else {
        //            request.predicate = categoryPredicate
        //        }
        //
        //        do {
        //            todoItems = try context.fetch(request)
        //        } catch {
        //            print("Error fetching data from context,\(error)")
        //        }
                
        //    }
        
    }
}
    
    //MARK: - Search Bar methods
    extension TodoListViewController: UISearchBarDelegate {
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//            let request : NSFetchRequest<Item> = Item.fetchRequest()
//
//            let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
//
//            request.predicate = predicate
//
//            let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
//
//            request.sortDescriptors = [sortDescriptor]
//
//            loadItems(with: request)
//
           
            
            
            todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
            tableView.reloadData()
    
        }
    
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
           if searchBar.text?.count == 0 {
                loadItems()
               DispatchQueue.main.async {
                   searchBar.resignFirstResponder()
               }
            }
        }
    }
    
    

