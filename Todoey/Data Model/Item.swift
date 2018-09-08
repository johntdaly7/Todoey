//
//  Item.swift
//  Todoey
//
//  Created by John Daly on 9/7/18.
//  Copyright © 2018 John Daly. All rights reserved.
//

import Foundation

class Item: Encodable, Decodable { //means that the Item type is able to encode (or decode) itself into a plist or into a JSON. In order to comform to these, the Item must only have standard data types. 'Encodable' and 'Decodable' can both be replaced to just have the word 'Codable'
    var title : String = ""
    var done: Bool  = false
}
