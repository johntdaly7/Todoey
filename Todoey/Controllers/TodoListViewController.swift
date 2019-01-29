//
//  ViewController.swift
//  Todoey
//
//  Created by John Daly on 9/7/18.
//  Copyright © 2018 John Daly. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UITableViewController { //adding all of these protocols/delegates can get crowded and confusing, so you can create a new class that acts as an extension to the TodoListViewController class below this class, and have that extension act as the delegate for the specific need (ie search bar or image picker, etc.) (can split up the functionality of the view controller so its more organized/modularized)
    
    //var itemArray = ["Find Mike", "Buy Eggos", "Destroy Demogorgon"]
    var itemArray = [Item]()
    
    var selectedCategory : Category? {
        didSet{ //everything between these curly braces is going to happen as soon as selectedCategory gets set with a value
            loadItems() //when we call loadItems(), we are certain that we got a value for our selected category, and we do not call loadItems() until we do have a value for our selected category
            
        }
    }
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext //gets access to the AppDelegate as a singleton object. Then grabs the persistent container of the AppDelegate (the persistent container is the persistent data storage (Core Data database). Then we grab the Context of the persistent container (what the app interacts with in order to interact with the persistent container (the Context is the intermediary between the app and the persistent data storage (this workflow is very similar to Git).
    
    //let defaults = UserDefaults.standard //UserDefaults: an interface to the user's defaults database, where you store key-value pairs persistently across launches of the app. UserDefaults should only be used to save/persist small bits of data (like a volumne value or boolean or player name, should not use arrays often or heavily) (should not be used as a database). Just to get one value from the Defaults, the iPhone/Device has to load ALL of the defaults, instead of just that one value. UserDefaults is a singleton
    
    //let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist") //the user domain mask is the user's home directory -> the place where we are to save their personal items associated with this current app. We grab the first item because this is an array.

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        //hardcoded item initialization for when we were testing:
//        let newItem = Item()
//        newItem.title = "Find Mike"
//        itemArray.append(newItem)
//
//        let newItem2 = Item()
//        newItem2.title = "Buy Eggos"
//        itemArray.append(newItem)
//
//        let newItem3 = Item()
//        newItem3.title = "Destroy Demogorgon"
//        itemArray.append(newItem)
        
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
//            itemArray = items
//        }
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))//.first?.appendingPathComponent("Items.plist")) //get a path for where the data is being stored for our current app
        
        //searchBar.delegate = self //you can do this in code, or you can right click and drag on the searchbar in the main.storyboard and drag it to the yellow circle icon (which represents the view controller) and then click on "delegate", which does the same thing as this line of code (which is what i did) (sets the delegate of the searchbar to the view controller
        
        //loadItems() //update the UI by loading the data of the itemArray
        
    }


    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let cell = UITableViewCell(style: .default, reuseIdentifier: "ToDoItemCell") //once the cell goes off the screen, it gets deallocated and destroyed
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath) //reuses the cells once they go off screen
        
        let item = itemArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        //Ternary operator ==>
        // value = condition ? valueIfTrue : valueIfFalse
        
        cell.accessoryType = item.done == true ? .checkmark : .none //this ternary operator does the exact same thing as the below commented out if-else statement
        
//        if item.done == true {
//            cell.accessoryType = .checkmark
//        }
//        else {
//            cell.accessoryType = .none
//        }
        
        return cell
    }
    
    //MARK - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
    
        //The below line of code adds a checkmark to the cell in the tableview
        //tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        
        //The below code adds or removes the checkmark from the cell in the tableview, depending on if the checkmark already exists or not
        //if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
        //    tableView.cellForRow(at: indexPath)?.accessoryType = .none
        //} else {
        //    tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        //}
        
        //The below line of code removes the gray shade on the cell (which is added when it is selected) when deselecting the cell (removing your finger)
        //tableView.deselectRow(at: indexPath, animated: true)
        
        //itemArray[indexPath.row],setValue("Completed", forKey: "title")//can change the title of the item in the todo-list to display "Completed" in the textfield when the item is completed
        
        
        //deleting data from the Core Data persistent data storage: (the order of these two lines of code matters A LOT)
        //itemArray.remove(at: indexPath.row) //remove the selected item from the list (this lowers the amount of items in the list (decreases the length of the list)
        //context.delete(itemArray[indexPath.row]) //update the context with the change of the removed item (if the length of the list is decreased, then the indexPath.row throws an index out of bounds error if the last item in the array is clicked to be removed. Or, if an item at the top or in the middle of the list is clicked/selected to be removed, then that item will be removed from the list, but then the context will delete the next item (and not the item that was selected) from the persistent data storage, causing that item to be removed from the list as well when updated.)
        
        //Because the current order of the above two lines throws an error, this is the CORRECT ORDER:
        //context.delete(itemArray[indexPath.row]) //remove the item from the persistent data storage first, then remove it from the itemArray.
        //itemArray.remove(at: indexPath.row)
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done //this line does the same as the below commented out if-else statement
        
        //when the user taps/clicks on the cell, the checkmark should be toggled either on or off (depending on whether or not the checkmark is already toggled on or off)
//        if itemArray[indexPath.row].done == false {
//            itemArray[indexPath.row].done = true
//        }
//        else {
//            itemArray[indexPath.row].done = false
//        }
        
        //save the current state of the context to the persistent data storage
        saveItems()
        
        tableView.deselectRow(at: indexPath, animated: true) //makes the row white again, instead of keeping it grey (which indicates it is selected)
    }
    
    //MARK - Add New Items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            //what will happen once the user clicks the Add Item button on our UIAlert
            //print("Success!")
            //print("textField.text")
            
            //Add the text to the item array
            //self.itemArray.append(textField.text!)
            
            //Save the updated itemArray to the user defaults (so that data can be persisted across sessions of the app) -> user defaults are default basic data of the app -> should be used sparingly
            //self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            //Reload the data so that the updated itemArray list is displayed in the UI
            //self.tableView.reloadData()
            
            //let newItem = Item()

            
            //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext //code in parentheses grabs the AppDelegate as an object, which we can then access the persistent container context from (this line is moved to the top so that it can be accessed globally)
            
            let newItem = Item(context: self.context) //create new item
            newItem.title = textField.text! //fill the item's fields
            newItem.done = false
            newItem.parentCategory = self.selectedCategory
            
            self.itemArray.append(newItem) //add the item to the item list
            //could also do this:
            //itemArray.append(textField.text ?? "New Item") //this means that if the textField.text is nil, append "New Item"
            
            //self.defaults.set(self.itemArray, forKey: "TodoListArray") //user defaults does not accept custom objects
            
            
            self.saveItems()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            //print(alertTextField.text)
            textField = alertTextField
            
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK - Model Manipulation Methods
    
    func saveItems() {
        //let encoder = PropertyListEncoder() //this encodes our data into a property list using NSCoder
        
        do {
            //let data = try encoder.encode(itemArray) //encodes data into a plist
            //try data.write(to: dataFilePath!) //write data to data file path
            try context.save() //transfers everything (unsaved changes) in the context to the permanent data storage
        } catch {
            //print("Error encoding item array, \(error)")
            print("Error saving context \(error)")
        }
        
        tableView.reloadData() //update the tableview UI display with the latest data
    }
    
    func loadItems(with request : NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) { //"with" is the external parameter, "request" is the internal parameter. The "= Item.fetchRequest() sets a default value of the parameter if no parameter is passed in to the function when the function is called (as in the loadItems() call in viewDidLoad())
        
//        if let data = try? Data(contentsOf: dataFilePath!) { //try? will turn the result of the Data() method into an optional. We use optional binding to unwrap that safely
//            let decoder = PropertyListDecoder() //this decodes our data from the property list using NSCoder
//            do {
//                itemArray = try decoder.decode([Item].self, from: data) //Decodes data into an array of Items. [Item] is the type of data that is being decoded
//            } catch {
//                print("Error decoding item array, \(error)")
//            }
//
//        }
        
        //let request : NSFetchRequest<Item> = Item.fetchRequest() //fetch the items that are in the persistent data storage //in Swift there are very few cases where you actually need to specify the datatype. In most cases, you specify the datatype because it helps you or people on your team to be able to easily see what is going on in your code. But in the majority of cases, Swift is clever enough to figure out what is the datatype just based on the value that you give it. But in this case it is a little bit different - you actually have to specify the datatype, and, most importantly, the Entity that you are trying to request (must specify the output of the request function).
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!) //return only all items associated with the selected parent category
        
        //combine the category predicate with the passed in predicate
        //let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, predicate])
        
        //request.predicate = compoundPredicate
        
        //need to make sure the passed in parameter predicate is not nil, so we use optional binding:
        if let additionalPredicate = predicate { //check to see if predicate is not nil
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        } else {
            request.predicate = categoryPredicate
        }
        
        do {
            itemArray = try context.fetch(request) //save the results of the persistent datastorage data fetch request inside the itemArray (so that the tableview can be populated)
        } catch {
            print("Error fetching data from context \(error)")
        }
        
        tableView.reloadData()
    }
    
    
}

//MARK: - Search bar methods
extension TodoListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //in this function we need to reload the table view using the text that the user has inputted
        
        //query the database and return the results
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        //print(searchBar.text!)
        
        //in order to query, we need an NSPredicate
        //let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!) //the %@ is the argument that is represents by the searchBar.text! //the [cd] means that the query is insensitive to case and diacritic (we need this since the queries are, by default, sensitive to case and diacritic) //LOOK AT NSPREDICATE CHEATSHEET FOR MORE SYMBOLS AND DEFINITIONS AND FORMATTING
        
        //request.predicate = predicate //add query to the request //(predicate specifies how we want to query our database)
        
        //the above two lines can be rewritten as such:
        //request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        //sort the data that we get back from the database
        //let sortDescriptor = NSSortDescriptor(key: "title", ascending: true) //sorts by title and by alphabetical order (ascending = alphabetical order)
        
        //request.sortDescriptors = [sortDescriptor] //result.sortDescriptors expects an array of sort descriptors
        
        //the above two lines can be rewritten as such:
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        //this do-catch block is repeated in loadItems(), so we can modify loadItems to instead take a parameter so that it fits our needs here:
//        do {
//            itemArray = try context.fetch(request) //assign results of the fetch to the itemArray
//        } catch {
//            print("Error fetching data from context \(error)")
//        }
        
        //the do-catch block can then be replaced with this line:
        //loadItems(with: request)
        
        //because the predicate gets overwritten when loadItems is called due to the change in predicate in order to load the corresponding categories, we need to differentiate between the load categories predicate and the search predicate, which is why we added a predicate parameter to the loadItems() function (so that both predicates can be sent with the request at the same time)
        loadItems(with: request, predicate: predicate)
        
        //tableView.reloadData() //update the UI (with updated itemArray) (commented out because tableView.reloadData() already exists in loadItems()
    }
    
    //checks when the text of the search bar changes
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //the addition of this if-statement means that if the text of the search bar changes, AND the number of characters in the searchBar goes down to 0 (so this method is not called when the searchBar is first loaded (and thus has no text in it), and is only called when the user hits the X button on the searchBar to clear the searchBar)
        if searchBar.text?.count == 0 {
            loadItems() //fetch all of the items from the persistent storage and updates the UI itemArray with the items
            
            //need to call resignFirstResponder() in the foreground because it is a method that affects the user interface
            DispatchQueue.main.async { //DispatchQueue is the manager that assigns the projects to different threads //the main thread is the one where you should be updating your user interface elements
               searchBar.resignFirstResponder() //no longer show the cursor in the searchBar and close the keyboard
            }
            
        }
    }
    
    
}

