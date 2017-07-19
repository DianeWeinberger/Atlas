//
//  User.swift
//  Atlas
//
//  Created by Magfurul Abeer on 7/19/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import Foundation
import RxRealm
import RealmSwift

class User: Object {
  dynamic var id: String = ""
  dynamic var firstName: String = ""
  dynamic var lastName: String = ""
  dynamic var email: String = ""
  var phoneNumber: RealmOptional<Int> = RealmOptional<Int>()
  dynamic var height: Double = 0
  dynamic var weight: Double = 0
  dynamic var zipCode: Int = 0
//  dynamic var goals: List<String> = List<String()
  var runs: List<Run> = List<Run>()
  var history: List<Event> = List<Event>()
  var friends: List<User> = List<User>()
  
  override static func primaryKey() -> String? {
    return "id"
  }
  
  override static func indexedProperties() -> [String] {
    return ["firstName", "lastName", "email", "zipCode"]
  }
}
