//
//  AppDelegate.swift
//  Atlas
//
//  Created by Magfurul Abeer on 7/18/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import UIKit
import Dotzu
import NSObject_Rx
import RealmSwift
import AWSCognitoIdentityProvider

// TODO: Turn off Allow Arbitrary Loads in NSAppTransportSecurity in Info.plist

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
    #if DEBUG
      Dotzu.sharedManager.enable()
    #endif
    
    
    let coordinator = Coordinator(window: window!)
    
    AuthService.initialize()
    /*
    let realm = try! Realm()
    let ironMan = realm.object(ofType: User.self, forPrimaryKey: "0")
    
    if ironMan == nil {
      let tony = MockUser.ironMan()
      let steve = MockUser.captainAmerica()
      let bruce = MockUser.hulk()
      
      tony.friends.append(objectsIn: [steve, bruce])
      do {
        try realm.write {
          realm.add([tony, steve, bruce])
        }
      } catch {
        print("Could not save to realm")
      }
    }
     */
    
    if AuthService.isSignedIn {
      // DRY this out
      let homeViewModel = HomeViewModel(coordinator: coordinator)
      let connectViewModel = ConnectViewModel(coordinator: coordinator)
      let profileViewModel = ProfileViewModel(coordinator: coordinator)
      let tabbarViewModel = AtlasTabBarViewModel(coordinator: coordinator)
      let viewModels: MainViewModels = (tabbarViewModel, homeViewModel, connectViewModel, profileViewModel)
      
      let mainScene = MainScene.main(viewModels)
      coordinator.transition(to: mainScene, type: .root)
      
    } else {
      
      let landingViewModel = LandingViewModel(coordinator: coordinator)
      let landingScene = AuthScene.landing(landingViewModel)
      coordinator.transition(to: landingScene, type: .root)
      
    }

    
    return true
  }
  
  
  
}


class AuthenticationDelegate: NSObject, AWSCognitoIdentityInteractiveAuthenticationDelegate {
  func getDetails(_ authenticationInput: AWSCognitoIdentityPasswordAuthenticationInput,
                  passwordAuthenticationCompletionSource: AWSTaskCompletionSource<AWSCognitoIdentityPasswordAuthenticationDetails>) {
    
    print("DONE")
    
  }
  
  func didCompleteStepWithError(_ error: Error?) {
    print("ERROR: \(error?.localizedDescription)")
  }
}

