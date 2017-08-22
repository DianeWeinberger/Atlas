//
//  Realm.swift
//  Atlas
//
//  Created by Magfurul Abeer on 8/22/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

extension Realm {
  
  // Make safer
  static func currentUser() throws -> User {
    let realm = try! Realm()
    let id = UserDefaults.standard.string(forKey: "username")
    guard let user = realm.object(ofType: User.self, forPrimaryKey: id ?? "") else {
      throw Realm.Error(.fileNotFound)
    }
    return user
  }
  
  static func write(_ block: (() throws -> Void)) throws {
    do {
      let realm = try Realm()
      try realm.write {
        try block()
      }
    } catch {
      // Implement error handling
    }
  }
  
  static func clear() {
    let realm = try! Realm()
    try! realm.write {
      realm.deleteAll()
    }
  }
}
