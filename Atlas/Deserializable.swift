//
//  Deserializable.swift
//  Atlas
//
//  Created by Magfurul Abeer on 8/22/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//


import Foundation
import RealmSwift

enum JSONDeserializationError: Error {
  case missingAttribute
  case invalidAttributeType
}

typealias JSONArray = [JSONDictionary]

protocol Deserializable {
  static func deserialize(_ json: JSONDictionary) -> Self
  static func deserialize(_ json: JSONArray) -> [Self]
}

extension Deserializable {
  static func deserialize(_ json: JSONArray) -> [Self] {
    var list = [Self]()
    
    for jsonDictionary in json {
      let new = deserialize(jsonDictionary)
      list.append(new)
    }
    
    return list
  }
  
  public func decode<T>(_ dictionary: JSONDictionary, key: String) throws -> T {
    guard let value = dictionary[key] else {
      throw JSONDeserializationError.missingAttribute//(key: key)
    }
    
    guard let attribute = value as? T else {
      throw JSONDeserializationError.invalidAttributeType//(key: key, expectedType: T.self, receivedValue: value)
    }
    
    return attribute
  }
}
