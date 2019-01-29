//
//  CategoryViewController.swift
//  Todoey
//
//  Created by John Daly on 1/28/19.
//  Copyright © 2019 John Daly. All rights reserved.
//

import UIKit
//import CoreData
import RealmSwift

class CategoryViewController: UITableViewController {

    let realm = try! Realm()
    
    
    //var categories = [Category]()
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext //no longer need context because we are using Realm instead of Core Data
    
    var categories: Results<Category>? //datatype of realm.objects is of type Results, so the datatype of categories needs to be changed to type Results (which is a type from Realm) to be consistent //categories needs to be an Optional because if we, for example, forgot to load up our categories and categories was nil, it would throw an error
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()

    }

    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories?.count ?? 1 //checks to see if categories is nil. if it is not nil, then return categories.count. if it is nil, then just return 1 (so our table view will have just 1 row) // the ?? operator is called the Nil Coalescing Operator
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        //let category = categories[indexPath.row]
        
        //cell.textLabel?.text = category.name
        
        //the above two lines can be combined into this one line:
        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet" //if the categories variable is not nil, then set the cell text to the corresponding category name. If the categories varibale is nil, then set the text to "No Categories Added Yet"
        
        return cell
        
    }
    
    //MARK: - TableView Delegate Methods
    //triggers when we select one of the cells
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //when a cell is selected, we want to trigger the seque from the Category view controller to the Item view controller
        performSegue(withIdentifier: "gotoItems", sender: self)
    }
    //prepares the ToDoListViewController with the appropriate data corresponding to the cell that was selected in the CategoryViewController, just before the seque is performed
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! TodoListViewController //stores a reference to the destination view controller //downcast as a TodoListViewController because we know where the segue will take us. If there are multiple possibilities of where the segue might take us, an if-statement checking the withIdentifier string in performSegue would be appropriate
        
        if let indexPath = tableView.indexPathForSelectedRow { //checks to see if the indexPath is nil -> checks to see if a cell is selected
            
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
        
        
    }
    
    
    //MARK: - Data Manipulation Methods
    
    func save(category: Category) { //func saveCategories() {
        
        do {
            //try context.save() //since we are no longer using the context (no longer using Core Data), we do not need this line)
            //instead try to write to the Realm database:
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    func loadCategories() {
        
        //all of the below commented out code (used for Core Data) can be replaced, in functionality, with the below line of code (used for Realm)
        categories = realm.objects(Category.self) //this pulls out all of the Items inside our Realm that are of Category objects
        
//        let request : NSFetchRequest<Category> = Category.fetchRequest()
//
//        do {
//            categories = try context.fetch(request)
//        } catch {
//            print("Error loading categories \(error)")
//        }
//
        tableView.reloadData()
    }
    
    //MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            //let newCategory = Category(context: self.context)
            
            //we not longer need to use the context because we are using realm and can use the Category() data model
            let newCategory = Category()
            newCategory.name = textField.text!
            
            //self.categories.append(newCategory) //because categories is of datatype Results, and because Results automatically updates and monitors for changes, we do not need to append the newCategory to the datatype
            
            //self.saveCategories()
            self.save(category: newCategory)
        }
        
        alert.addAction(action)
        
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Add a new category"
        }
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    
    
}
