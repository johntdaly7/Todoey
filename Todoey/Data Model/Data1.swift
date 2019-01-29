//
//  Data.swift
//  Todoey
//
//  Created by John Daly on 1/28/19.
//  Copyright © 2019 John Daly. All rights reserved.
//

import Foundation
import RealmSwift

//example class of a Realm object
class Data1: Object { //Object is a class used to define Realm model objects
    @objc dynamic var name : String = "" //because we are using Realm, we need to mark our variables with a keyword - dynamic - dynamic is a declaration modifier...it basically tells the runtime to use dynamic dispatch over the standard static dispatch. This basically allows this property - name - to be monitored for change at runtime (while the app is running). If the user changes the value of name while the app is running, then that allows Realm to dynamically update those changes in the database. But dynamic dispatch is actually something that comes from the Objective C APIs, so that means that we actually have to mark dynamic with @objc to be explicit that we are using the Objective C runtime. Whenever declaring a new Realm property that is any of the basic datatypes, you will need these two keywords in front of it.
    @objc dynamic var age: Int = 0
}
