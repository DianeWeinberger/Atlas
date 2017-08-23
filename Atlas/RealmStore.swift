//
//  RealmStore.swift
//  Atlas
//
//  Created by Magfurul Abeer on 8/23/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import Foundation
import RealmSwift

enum RealmStoreError {
  case couldNotInitializeRealm
}

struct RealmStore {
  static let shared = RealmStore()
  
//  var realm: Realm!
//  
//  init() {
//    do {
//      self.realm = try Realm()
//    } catch {
//      throw RealmStoreError.couldNotInitializeRealm
//    }
//  }
}
