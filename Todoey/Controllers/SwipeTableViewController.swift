//
//  SwipeTableViewController.swift
//  Todoey
//
//  Created by John Daly on 1/29/19.
//  Copyright © 2019 John Daly. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        //increase the size of each cell so that the delete icon and text show up nicely (and are not vertically cramped, as they were originally)
        tableView.rowHeight = 80.0 

    }
    
    //TableView Datasource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        
        //the below line is not needed for the SwipeTableViewCell implementation, as we do not know of categories or items in this parent class
        //cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added Yet" //if the categories variable is not nil, then set the cell text to the corresponding category name. If the categories variable is nil, then set the text to "No Categories Added Yet"
        
        cell.delegate = self //for the implemenation of SwipeTableViewCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            //handle action by updating model with deletion
            //print("Item deleted")
            
            //print("Delete Cell")
            
            self.updateModel(at: indexPath)
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
            
        }
        
        //customize the action appearance
        deleteAction.image = UIImage(named: "delete-icon")
        
        return [deleteAction]
        
    }
    
    //function for being able to delete the cell by swiping it all the way over to the left:
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
        options.expansionStyle = .destructive
        //options.transitionStyle = .border //this is just for style (expandng the options smoothly)
        return options
    }

    func updateModel(at indexPath: IndexPath) {
        //update our data model.
    }
    
}

