//
//  Run.swift
//  Atlas
//
//  Created by Magfurul Abeer on 7/19/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import Foundation
import RxRealm
import RealmSwift

class Run: Object {
  dynamic var id: String = ""
  dynamic var timestamp: Date = Date()
  dynamic var type: String = ""
  dynamic var time: TimeInterval = 0
  dynamic var distance: Double = 0
  dynamic var pace: Double = 0
  dynamic var runner: User = User()
  
  override static func primaryKey() -> String? {
    return "id"
  }
  
  override static func indexedProperties() -> [String] {
    return ["timestamp"]
  }
}
