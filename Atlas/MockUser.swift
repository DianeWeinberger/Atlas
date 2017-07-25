//
//  MockUser.swift
//  Atlas
//
//  Created by Magfurul Abeer on 7/24/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import UIKit
import RealmSwift

struct MockUser {
  static func ironMan() -> User {
    let tony = User()
    tony.id = "0"
    tony.firstName = "Tony"
    tony.lastName = "Stark"
    tony.email = "tony@starkindustries.com"
    tony.height = 69
    tony.weight = 150
    tony.zipCode = 10001
    tony.imageURL = "http://vignette4.wikia.nocookie.net/marvelmovies/images/9/9a/Iron-man-site-tony-stark.jpg"
    tony.friends = List<User>()
    tony.history = List<Event>()
    tony.runs = List<Run>()
    
    return tony
  }
  
  static func captainAmerica() -> User {
    let cap = User()
    cap.id = "1"
    cap.firstName = "Steve"
    cap.lastName = "Rogers"
    cap.email = "steve@avengers.net"
    cap.height = 72
    cap.weight = 180
    cap.zipCode = 10001
    cap.imageURL = "http://cdn3-www.superherohype.com/assets/uploads/gallery/captain_america_4979/captain_america_the_winter_soldier_7927/captws_captainamerica_avatar.jpg"
    cap.friends = List<User>()
    cap.history = List<Event>()
    cap.runs = List<Run>()
    
    
    let event1 = Event()
    event1.id = "1-1"
    event1.title = "just improved his speed."
    event1.timestamp = Date().before(days: 2).after(minutes: 30)
    
    let event2 = Event()
    event2.id = "1-2"
    event2.title = "just completed a 5K!"
    event2.timestamp = Date().before(days: 2).after(hours: 2)

    cap.history.append(objectsIn: [event1, event2])
    
    return cap
  }
  
  static func hulk() -> User {
    let bruce = User()
    bruce.id = "2"
    bruce.firstName = "Bruve"
    bruce.lastName = "Banner"
    bruce.email = "bruce@avengers.net"
    bruce.height = 69
    bruce.weight = 140
    bruce.zipCode = 10001
    bruce.imageURL = "http://static.tumblr.com/jds6vf6/XS1maszup/avengersmarkruffalobrucebanner.png"
    bruce.friends = List<User>()
    bruce.history = List<Event>()
    bruce.runs = List<Run>()
    
    let event1 = Event()
    event1.id = "2-1"
    event1.title = "just improved his speed."
    event1.timestamp = Date().before(days: 2)
    
    let event2 = Event()
    event2.id = "2-2"
    event2.title = "just ran 11.3 miles!"
    event2.timestamp = Date().before(days: 1)
    
    let event3 = Event()
    event3.id = "2-3"
    event3.title = "just completed a 5K!"
    event3.timestamp = Date().before(minutes: 30)
    
    bruce.history.append(objectsIn: [event1, event2, event3])
    
    return bruce
  }

}
