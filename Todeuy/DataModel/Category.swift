//
//  Category.swift
//  Todeuy
//
//  Created by 송하민 on 2021/08/26.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name:String = ""
    let items = List<Item>()
}
