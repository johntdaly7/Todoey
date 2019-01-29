//
//  Item.swift
//  Todoey
//
//  Created by John Daly on 1/28/19.
//  Copyright © 2019 John Daly. All rights reserved.
//

import Foundation
import RealmSwift

//this class is meant to be a copy/replacement for the DataModel Entity Item
class Item: Object {
    @objc dynamic var title:  String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items") //inverse relationship of items with categories -> each item has an inverse relationship to a category called the parent category //LinkingObjects is an auto-updating container type. It represents zero or more objects that are linked to its owning model object through a property relationship.
    //if we just say Category for the fromType, then it would just be the class. In order to make it the type (of Category), we have to make it Category.self
    //"items" is the name of the forward relationship in the category class. This string points to that forward relationship "items" in the type "Category"
}
