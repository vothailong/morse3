//
//  Item.swift
//  Todoey
//
//  Created by Philipp Muellauer on 29/11/2019.
//  Copyright © 2019 Philipp Muellauer. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object, Identifiable {
    let id = UUID()
    @objc dynamic var content: String = ""
    @objc dynamic var pin: Bool = false
    @objc dynamic var dateCreated = Date()
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
