//
//  Storyboard.swift
//  Atlas
//
//  Created by Magfurul Abeer on 8/25/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import UIKit

struct Storyboard {
  static let auth = AuthStoryboard("Auth")
  static let onboarding = UIStoryboard(name: "Onboarding", bundle: nil)
  static let main = UIStoryboard(name: "Main", bundle: nil)
  static let home = UIStoryboard(name: "Home", bundle: nil)
  static let run = UIStoryboard(name: "Run", bundle: nil)
  static let connect = UIStoryboard(name: "Connect", bundle: nil)
  static let profile = UIStoryboard(name: "Profile", bundle: nil)

//  var fileName: String
//  
//  init(_ fileName: String) {
//    self.fileName = fileName
//  }
  
}

protocol StoryboardType {
  var storyboard: UIStoryboard { get set }
}

struct AuthStoryboard: StoryboardType {
  var storyboard: UIStoryboard
  
  init(_ name: String) {
    storyboard = UIStoryboard(name: name, bundle: nil)
  }
  
  func login() -> LogInViewController {
    return storyboard.instantiateViewController(withIdentifier: "login") as! LogInViewController
  }
  
  func signup() -> LogInViewController {
    return storyboard.instantiateViewController(withIdentifier: "signup") as! LogInViewController
  }
}



func abc() {
  Storyboard.auth.login()
}
