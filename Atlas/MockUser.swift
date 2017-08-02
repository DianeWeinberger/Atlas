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

    let event1 = Event()
    event1.id = "0-1"
    event1.title = "just improved his speed."
    event1.timestamp = Date().before(days: 3).after(minutes: 30)
    event1.user = tony
    
    let event2 = Event()
    event2.id = "0-2"
    event2.title = "just completed a 5K!"
    event2.timestamp = Date().before(days: 4).after(hours: 2)
    event2.user = tony
    tony.history.append(objectsIn: [event1, event2])
//    
//    
//
//    let run1 = Run()
//    run1.timestamp = Date().before(months: 1).after(days: 7)
//    run1.distance = 3
//    run1.pace = 2.5
//    run1.time = 100
//    run1.runner = tony
//    
//    let run2 = Run()
//    run2.timestamp = Date().before(months: 3).after(days: 15)
//    run2.distance = 1
//    run2.pace = 1.8
//    run2.time = 150
//    run1.runner = tony
    
    tony.runs = MockUser.generateRuns(user: tony)
    
    tony.friends.append(objectsIn: [captainAmerica(), hulk()])
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
    
    let event1 = Event()
    event1.id = "1-1"
    event1.title = "just improved his speed."
    event1.timestamp = Date().before(days: 2).after(minutes: 30)
    event1.user = cap
    
    let event2 = Event()
    event2.id = "1-2"
    event2.title = "just completed a 5K!"
    event2.timestamp = Date().before(days: 2).after(hours: 2)
    event2.user = cap
    
    cap.history.append(objectsIn: [event1, event2])
    
//    cap.friends.append(objectsIn: [ironMan(), hulk()])
    cap.runs = MockUser.generateRuns(user: cap)
    
    return cap
  }
  
  static func hulk() -> User {
    let bruce = User()
    bruce.id = "2"
    bruce.firstName = "Bruce"
    bruce.lastName = "Banner"
    bruce.email = "bruce@avengers.net"
    bruce.height = 69
    bruce.weight = 140
    bruce.zipCode = 10001
    bruce.imageURL = "http://static.tumblr.com/jds6vf6/XS1maszup/avengersmarkruffalobrucebanner.png"

    let event1 = Event()
    event1.id = "2-1"
    event1.title = "just improved his speed."
    event1.timestamp = Date().before(days: 2)
    event1.user = bruce
    
    let event2 = Event()
    event2.id = "2-2"
    event2.title = "just ran 11.3 miles!"
    event2.timestamp = Date().before(days: 1)
    event2.user = bruce
    
    let event3 = Event()
    event3.id = "2-3"
    event3.title = "just completed a 5K!"
    event3.timestamp = Date().before(minutes: 30)
    event3.user = bruce
    
    bruce.history.append(objectsIn: [event1, event2, event3])
    bruce.runs = MockUser.generateRuns(user: bruce)

//    bruce.friends.append(objectsIn: [ironMan(), captainAmerica()])

    return bruce
  }
  
  static func dareDevil() -> User {
    let matt = User()
    matt.id = "3"
    matt.firstName = "Matt"
    matt.lastName = "Murdock"
    matt.email = "matt@murdockandnelson.com"
    matt.height = 70
    matt.weight = 140
    matt.zipCode = 10010
    matt.imageURL = "http://orig09.deviantart.net/6b4d/f/2015/210/d/0/woah_baby___matt_murdock_x_reader_by_latte_to_go-d93bxt6.jpg"

    let event1 = Event()
    event1.id = "3-1"
    event1.title = "just improved his speed."
    event1.timestamp = Date().before(days: 1).after(minutes: 20)
    event1.user = matt
    
    let event2 = Event()
    event2.id = "3-2"
    event2.title = "just ran 11.3 miles!"
    event2.timestamp = Date().before(days: 3).before(minutes: 50)
    event2.user = matt
    
    let event3 = Event()
    event3.id = "3-3"
    event3.title = "just completed a 5K!"
    event3.timestamp = Date().before(days: 5).before(minutes: 30)
    event3.user = matt
    
    matt.history.append(objectsIn: [event1, event2, event3])
    matt.runs = MockUser.generateRuns(user: matt)

    return matt
  }
}

extension MockUser {
  static func generateRuns(user: User) -> List<Run> {
    let generatedRuns = (0...arc4random_uniform(15)).map { _ -> Run in
      let months = Int(arc4random_uniform(6))
      let days = Int(arc4random_uniform(30)) - Int(arc4random_uniform(60))
      let minutes = Int(arc4random_uniform(300)) - Int(arc4random_uniform(300))
      let distance = Double(arc4random_uniform(2000)) / 100
      let pace = Double(arc4random_uniform(1500)) / 100
      let time = Double(arc4random_uniform(1000)) / Double(arc4random_uniform(80))
      
      let run = Run()
      run.timestamp = Date().before(months: months).after(days: days).before(minutes: minutes)
      run.distance = distance
      run.pace = pace
      run.time = time
      run.runner = user
      
      return run
    }
    
    let list = List<Run>()
    list.append(objectsIn: generatedRuns)
    return list
  }
}
