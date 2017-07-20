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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?


  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    
    #if DEBUG
      Dotzu.sharedManager.enable()
    #endif
    
    let loggedIn = true
    
    let coordinator = Coordinator(window: window!)
    
    if loggedIn {
      let runViewModel = RunViewModel(coordinator: coordinator)
      let tabbarViewModel = AtlasTabBarViewModel(coordinator: coordinator)
      let viewModels: MainViewModels = (tabbarViewModel, runViewModel)
      
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

