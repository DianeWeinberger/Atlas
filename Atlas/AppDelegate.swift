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
import Lock
import Auth0
import SimpleKeychain

// TODO: Turn off Allow Arbitrary Loads in NSAppTransportSecurity in Info.plist

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?


  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
    #if DEBUG
      Dotzu.sharedManager.enable()
    #endif
    
    let coordinator = Coordinator(window: window!)
    let keychain = A0SimpleKeychain(service: "Auth0")
    
    if let accessToken = keychain.string(forKey: "access_token") {
      print("ACCESS TOKEN IS")
      print(accessToken)
    } else {
      print("NO ACCESS TOKEN")
      displayLandingPage(coordinator)
    }
    
//    print(keychain.string(forKey: "access_token"))
//    if let accessToken = keychain.string(forKey: "access_token") {
//      print(accessToken)
//      print("HAS AUTH TOKEN")
//      Auth0
//        .authentication()
//        .userInfo(withAccessToken: accessToken)
//        .start { result in
//          switch result {
//          case .success(let profile):
//            print("*********")
//            print(profile)
////            profile.
//            // The accessToken is still valid and you have the user's profile
//            // This would be a good time to store the profile
//            return
//          case .failure(let error):
//            print(error.localizedDescription)
//            return
//          }
//        }
//      
//      displayTabbar(coordinator)
//    } else {
//      
//      let keychain = A0SimpleKeychain(service: "Auth0")
//      guard let refreshToken = keychain.string(forKey: "refresh_token") else {
//        keychain.clearAll()
//        return true
//      }
//      Auth0
//        .authentication()
//        .renew(withRefreshToken: refreshToken, scope: "openid profile offline_access")
//        .start { result in
//          switch(result) {
//          case .success(let credentials):
//            // Just got a new accessToken!
//            // Don't forget to store it...
//            guard let accessToken = credentials.accessToken else { return }
//            keychain.setString(accessToken, forKey: "access_token")
//          // At this point, you can log the user into your app. e.g. by navigating to the corresponding screen
//          case .failure(let error):
//            // refreshToken is no longer valid (e.g. it has been revoked)
//            // Cleaning stored values since they are no longer valid
//            keychain.clearAll()
//            // At this point, you should ask the user to enter their credentials again!
//          }
//      }
//      
//    }
    
    
    
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
    

    
    return true
  }
  
  
  func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
    return Lock.resumeAuth(url, options: options)
  }
}

extension AppDelegate {
  func displayLandingPage(_ coordinator: CoordinatorType) {
    let landingViewModel = LandingViewModel(coordinator: coordinator)
    let landingScene = AuthScene.landing(landingViewModel)
    coordinator.transition(to: landingScene, type: .root)
  }
  
  func displayTabbar(_ coordinator: CoordinatorType) {
    let connectViewModel = ConnectViewModel(coordinator: coordinator)
    let tabbarViewModel = AtlasTabBarViewModel(coordinator: coordinator)
    let viewModels: MainViewModels = (tabbarViewModel, connectViewModel)
    
    let mainScene = MainScene.main(viewModels)
    coordinator.transition(to: mainScene, type: .root)
  }
}

extension AppDelegate {
  func logout() {
    let keychain = A0SimpleKeychain(service: "Auth0")
    keychain.clearAll()
  }
}

