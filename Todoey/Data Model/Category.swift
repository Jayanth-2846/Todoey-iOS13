//
//  Category.swift
//  Todoey
//
//  Created by Jayanth Ambaldhage on 22/04/23.
//  Copyright © 2023 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    let items = List<Item>()
}
