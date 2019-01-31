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
//import SwipeCellKit
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {

    let realm = try! Realm()
    
    
    //var categories = [Category]()
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext //no longer need context because we are using Realm instead of Core Data
    
    var categories: Results<Category>? //datatype of realm.objects is of type Results, so the datatype of categories needs to be changed to type Results (which is a type from Realm) to be consistent //categories needs to be an Optional because if we, for example, forgot to load up our categories and categories was nil, it would throw an error
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()

        //increase the size of each cell so that the delete icon and text show up nicely (and are not vertically cramped, as they were originally)
        //tableView.rowHeight = 80.0 //moved to SwipeTableViewController for consistency across both CategoryViewController and TodoListViewController
        
        //remove the separator lines between cells (in order to have the colors of the cells "bleed" into each other
        tableView.separatorStyle = .none
        
        
    }

    //MARK: - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categories?.count ?? 1 //checks to see if categories is nil. if it is not nil, then return categories.count. if it is nil, then just return 1 (so our table view will have just 1 row) // the ?? operator is called the Nil Coalescing Operator
    }
        
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        //the below line was commented out because it was for when we had SwipeTableViewController Extension in this class instead of as a separate class
        //let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! SwipeTableViewCell //this is the same as the above line of code, only we downcast the cell as a SwipeTableViewCell for the implementation of Swipable Cells to improve the UI and for the deletion of categories.
        
        //let category = categories[indexPath.row]
        
        //cell.textLabel?.text = category.name
        
        //the above two lines can be combined into this one line:
         //the below line was commented out because it was for when we had SwipeTableViewController Extension in this class instead of as a separate class
        //cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet" //if the categories variable is not nil, then set the cell text to the corresponding category name. If the categories varibale is nil, then set the text to "No Categories Added Yet"
        
         //the below line was commented out because it was for when we had SwipeTableViewController Extension in this class instead of as a separate class
        //cell.delegate = self //for the implemenation of SwipeTableViewCell
        
         //the below line was commented out because it was for when we had SwipeTableViewController Extension in this class instead of as a separate class
        //return cell
        
        //NEW CODE FOR SwipeTableViewCell IMPLEMENTATION:
        
        //trigger the code in the super class to create a SwipeTableViewCell
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categories?[indexPath.row] {
            cell.textLabel?.text = category.name //?? "No Categories Added Yet"
            
            
            guard let categoryColour = UIColor(hexString: category.colour) else {fatalError()}
            //change the cell background color here:
            cell.backgroundColor = categoryColour //?? "")
            
            //change the color of the text of the cell so that it contrasts the color of the cell's background
            cell.textLabel?.textColor = ContrastColorOf(categoryColour, returnFlat: true)
        }
        
        
        return cell
        
    }
    
    //MARK: - TableView Delegate Methods
    //triggers when we select one of the cells
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //when a cell is selected, we want to trigger the seque from the Category view controller to the Item view controller
        performSegue(withIdentifier: "goToItems", sender: self)
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
    
    //MARK: - Delete Data From Swipe
    override func updateModel(at indexPath: IndexPath) {
        if let categoryForDeletion = self.categories?[indexPath.row] {
            do {
                //update the realm
                try self.realm.write {
                    self.realm.delete(categoryForDeletion)
                }
            } catch {
                print("Error deleting category, \(error)")
            }

        }
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
            newCategory.colour = UIColor.randomFlat.hexValue()
            
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

//MARK: - Swipe Cell Delegate Methods
//this was moved to the SwipeTableViewController so that the code is not repeated when implementing the same thing for the TodoListViewController
//extension CategoryViewController: SwipeTableViewCellDelegate {
//
//    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
//        guard orientation == .right else { return nil }
//
//        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
//            //handle action by updating model with deletion
//            //print("Item deleted")
//
//            if let categoryForDeletion = self.categories?[indexPath.row] {
//                do {
//                    //update the realm
//                    try self.realm.write {
//                        self.realm.delete(categoryForDeletion)
//                    }
//                } catch {
//                    print("Error deleting category, \(error)")
//                }
//
//                //tableView.reloadData()
//            }
//
//        }
//
//        //customize the action appearance
//        deleteAction.image = UIImage(named: "delete-icon")
//
//        return [deleteAction]
//
//    }
//
//    //function for being able to delete the cell by swiping it all the way over to the left:
//    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
//        var options = SwipeTableOptions()
//        options.expansionStyle = .destructive
//        //options.transitionStyle = .border //this is just for style (expandng the options smoothly)
//        return options
//    }
//
//
//}
