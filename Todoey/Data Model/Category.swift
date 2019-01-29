//
//  Category.swift
//  Todoey
//
//  Created by John Daly on 1/28/19.
//  Copyright © 2019 John Daly. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>() //list of items to represent the relationship between categories and items -> each category has a one to may relationship with a list of items //class List comes from a Realm framework
    
    //different ways of declaring an array:
    //let array = [1,2,3] //array that uses type-inference and is populated with integers 1, 2, and 3
    //let array = [Int]() //array of type integer that is initialized as an empty array
    //let array : [Int] = [1,2,3] //explicit declaration of the type of the array, and the initialization of the array with integers 1, 2, and 3
    //let array : Array<Int> = [1,2,3] //explicitly declares the constant as an array with type integer, and initializes the array with integers 1, 2, and 3
    //let array = Array<Int>() //initializes an empty array of integers
    
    
    
    
    
}
