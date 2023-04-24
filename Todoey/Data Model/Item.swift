//
//  Item.swift
//  Todoey
//
//  Created by Jayanth Ambaldhage on 22/04/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift
class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
