//
//  Event.swift
//  Atlas
//
//  Created by Magfurul Abeer on 7/19/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import Foundation
import RxRealm
import RealmSwift

class Event: Object {
  dynamic var id: String = ""
  dynamic var timestamp: Date = Date()
  dynamic var title: String = ""
  dynamic var type: String = ""
  dynamic var user: User? = User()

  override static func primaryKey() -> String? {
    return "id"
  }
  
  override static func indexedProperties() -> [String] {
    return ["timestamp", "title"]
  }
  
  // TODO: Create generic
  static let sortEarliest: (Event, Event) -> Bool = { a, b in
    return a.timestamp.isBefore(date: b.timestamp)
  }
  
  static let sortLatest: (Event, Event) -> Bool = { a, b in
    return a.timestamp.isAfter(date: b.timestamp)
  }
}
