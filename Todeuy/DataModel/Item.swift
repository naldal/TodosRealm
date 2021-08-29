//
//  Item.swift
//  Todeuy
//
//  Created by 송하민 on 2021/08/26.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var createdDate: Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
