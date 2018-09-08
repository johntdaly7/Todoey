//
//  ViewController.swift
//  Todoey
//
//  Created by John Daly on 9/7/18.
//  Copyright © 2018 John Daly. All rights reserved.
//

import UIKit

class TodoListViewController: UITableViewController {
    
    //var itemArray = ["Find Mike", "Buy Eggos", "Destroy Demogorgon"]
    var itemArray = [Item]()
    
    //let defaults = UserDefaults.standard //UserDefaults: an interface to the user's defaults database, where you store key-value pairs persistently across launches of the app. UserDefaults should only be used to save/persist small bits of data (like a volumne value or boolean or player name, should not use arrays often or heavily) (should not be used as a database). Just to get one value from the Defaults, the iPhone/Device has to load ALL of the defaults, instead of just that one value. UserDefaults is a singleton
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist") //the user domain mask is the user's home directory -> the place where we are to save their personal items associated with this current app. We grab the first item because this is an array.

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
        
        loadItems()
        
    }


    //MARK - Tableview Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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
    
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done //this line does the same as the below commented out if-else statement
        
//        if itemArray[indexPath.row].done == false {
//            itemArray[indexPath.row].done = true
//        }
//        else {
//            itemArray[indexPath.row].done = false
//        }
        
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
            
            let newItem = Item()
            newItem.title = textField.text!
            
            self.itemArray.append(newItem)
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
        let encoder = PropertyListEncoder() //this encodes our data into a property list using NSCoder
        
        do {
            let data = try encoder.encode(itemArray) //encodes data into a plist
            try data.write(to: dataFilePath!) //write data to data file path
        } catch {
            print("Error encoding item array, \(error)")
        }
        
        self.tableView.reloadData()
    }
    
    func loadItems() {
        if let data = try? Data(contentsOf: dataFilePath!) { //try? will turn the result of the Data() method into an optional. We use optional binding to unwrap that safely
            let decoder = PropertyListDecoder() //this decodes our data from the property list using NSCoder
            do {
                itemArray = try decoder.decode([Item].self, from: data) //Decodes data into an array of Items. [Item] is the type of data that is being decoded
            } catch {
                print("Error decoding item array, \(error)")
            }
            
        }
    }
    
}

