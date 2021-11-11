//
//  CategoryViewController.swift
//  Todoey
//
//  Created by Philipp Muellauer on 28/11/2019.
//  Copyright © 2019 Philipp Muellauer. All rights reserved.

import UIKit
import RealmSwift
//import ChameleonFramework

class CategoryViewController {
    
    var realm: Realm!
    
    init (){
        print(Realm.Configuration.defaultConfiguration.fileURL)
        //init Realm
        if realm == nil {
            do {
                realm = try Realm()
            } catch {
                Log.error("Error initialising new realm, \(error)")
            }
        }
    }
    // Potential namespace clash with OpaquePointer (same name of Category)
    // Use correct type from dropdown or add backticks to fix e.g., var categories = [`Category`]()
    var categories: Results<Category>!
    func createDefaultCategory(){
        let newCategory = Category()
        newCategory.name = "default"// textField.text!
        self.save(category: newCategory)
    }
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category \(error)")
        }
    }
    
    func loadCategories() -> Results<Category>? {
        guard realm != nil else {
            Log.error("realm chưa khởi tạo")
            return nil
        }
        categories = realm.objects(Category.self)//lần đầu tiên tại sao ko = nil?
        //        if categories == nil {
        //            createDefaultCategory()
        //            categories = realm.objects(Category.self)
        //        }
        return categories
        // tableView.reloadData()
    }
    
    func addItemToCategory(item: Item, cat: Category) {
        do {
            try self.realm.write {
                cat.items.append(item)
            }
        } catch {
            print("Error saving new items, \(error)")
        }
        
    }
    
    func getDefaultCategory () -> Category? {
        return loadCategories()?.first
    }
    //    override func viewDidLoad() {
    //        super.viewDidLoad()
    //
    //        loadCategories()
    //        tableView.separatorStyle = .none
    //    }
    //
    //    override func viewWillAppear(_ animated: Bool) {
    //        guard let navBar = navigationController?.navigationBar else { fatalError("Navigation controller does not exist.")
    //        }
    //        navBar.backgroundColor = UIColor(hexString: "#1D9BF6")
    //    }
    //
    //    //Mark: - Tableview Datasource Methods
    //    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //        return categories?.count ?? 1
    //    }
    //
    //    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //
    //        let cell = super.tableView(tableView, cellForRowAt: indexPath)
    //        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories added yet"
    //
    //        if let category = categories?[indexPath.row] {
    //            guard let categoryColour = UIColor(hexString: category.colour) else {fatalError()}
    //            cell.backgroundColor = categoryColour
    //            cell.textLabel?.textColor = ContrastColorOf(categoryColour, returnFlat: true)
    //        }
    //        return cell
    //    }
    
    
    
    //Mark: - Delete Data from Swipe
    //    override func updateModel(at indexPath: IndexPath) {
    //        if let categoryForDeletion = self.categories?[indexPath.row] {
    //            do {
    //                try self.realm.write {
    //                    self.realm.delete(categoryForDeletion)
    //                }
    //            } catch {
    //                print("Error deleting category, \(error)")
    //            }
    //        }
    //    }
    
    //Mark: - Add New Categories
    //    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    //
    //        var textField = UITextField()
    //        let alert = UIAlertController(title: "Add a New Cateogry", message: "", preferredStyle: .alert)
    //        let action = UIAlertAction(title: "Add", style: .default) { (action) in
    //            let newCategory = Category()
    //            newCategory.name = textField.text!
    //            newCategory.colour = UIColor.randomFlat().hexValue()
    //            self.save(category: newCategory)
    //        }
    //
    //        alert.addAction(action)
    //        alert.addTextField { (field) in
    //            textField = field
    //            textField.placeholder = "Add a new category"
    //        }
    //        present(alert, animated: true, completion: nil)
    //    }
    
    //Mark: - Tableview Delegate Methods
    //    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    //        performSegue(withIdentifier: "goToItems", sender: self)
    //    }
    //
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        let destinationVC = segue.destination as! TodoListViewController
    //        if let indexPath = tableView.indexPathForSelectedRow {
    //            destinationVC.selectedCategory = categories?[indexPath.row]
    //        }
    //    }
    
    
    
}

