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
import RxSwift
import Dotzu


final class User: Object {
  dynamic var id: String = ""
  dynamic var firstName: String = ""
  dynamic var lastName: String = ""
  dynamic var email: String = ""
  dynamic var gender: String = ""
  var phoneNumber: RealmOptional<Int> = RealmOptional<Int>()
  dynamic var height: Double = 0
  dynamic var weight: Double = 0
//  dynamic var zipCode: Int = 0
  dynamic var city: String = ""
  dynamic var runPreference: String = "Free"
  dynamic var imageURL: String = ""
//  dynamic var goals: List<String> = List<String()
  
  dynamic var pace: TimeInterval = 0
  dynamic var distance: Double = 0
  dynamic var duration: TimeInterval = 0
  dynamic var totalMiles: Double = 0
  
  var runs: List<Run> = List<Run>()
  var history: List<Event> = List<Event>()
  var friends: List<User> = List<User>()
  
  var sentRequests: List<User> = List<User>()
  var recievedRequests: List<User> = List<User>()
  
  override static func primaryKey() -> String? {
    return "id"
  }
  
  override static func indexedProperties() -> [String] {
    return ["firstName", "lastName", "email", "zipCode"]
  }
  
}

extension User: Deserializable {
  static func deserialize(_ json: JSONDictionary) -> User {
    print("DESERIALIZING JSON")
    print(json)
    let user = User()
    user.id = json["id"] as! String
    user.email = json["email"] as! String
    user.firstName = json["firstName"] as! String
    user.lastName = json["lastName"] as! String
    
    do {
      try Realm.shared.write {
        Realm.shared.add(user)
      }
    } catch {
      // Implement error handling
    }
    
    return user
  }
}

extension User {
  var url: URL? {
    return URL(string: self.imageURL)
  }
  
  var fullName: String {
    return "\(firstName) \(lastName)"
  }
  
  var displayName: String {
    return "\(firstName) \(lastName.characters.first!)."
  }
  
  var initials: String {
    return "\(firstName.characters.first!)\(lastName.characters.first!)"
  }
  
  var stats: Observable<[StatBlock]> {
    return Observable.of([
      ("Average", "PACE", "\(pace)"),
      ("Average", "DISTANCE", "\(distance)"),
      ("Average", "DURATION", "\(duration)"),
      ("Total Miles", "RUN", "\(totalMiles)")
    ])
  }
  
  var friendsActivity: Observable<[Event]> {
    let friendHistory = friends.toArray()
      .flatMap { $0.history }
      .sorted(by: Event.sortLatest)
    
    return Observable.of(friendHistory)
  }
  
  var sortedRuns: [Run] {
    return runs.sorted(by: Run.sortLatest)
  }
  
  func relation(to user: User) -> UserRelationState {
    if friends.map({ $0.id }).contains(user.id) {
      return UserRelationState.friend
    }
    
    if sentRequests.map({ $0.id }).contains(user.id) {
      return UserRelationState.requestSent
    }

    if recievedRequests.map({ $0.id }).contains(user.id) {
      return UserRelationState.awaitingResponse
    }
    
    return UserRelationState.connect
  }
}

enum UserRelationState: String {
  case friend
  case requestSent
  case awaitingResponse
  case connect
}
