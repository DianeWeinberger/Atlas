//
//  MainScene.swift
//  Atlas
//
//  Created by Magfurul Abeer on 7/20/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import UIKit

typealias MainViewModels = (tabbar: AtlasTabBarViewModel, home: HomeViewModel,  connect: ConnectViewModel, profile: ProfileViewModel)

enum MainScene: SceneType {
  case main(MainViewModels)
}

extension MainScene {
  var viewController: UIViewController {
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    
    switch self {
    case .main(let viewModels):
      var tabbar = storyboard.instantiateViewController(withIdentifier: "main") as! AtlasTabBarController
      tabbar.bindViewModel(to: viewModels.tabbar)
      
      var home = tabbar.viewControllers![0] as! HomeViewController
      home.bindViewModel(to: viewModels.home)

      let connectNav = tabbar.viewControllers![1] as! UINavigationController
      var connect = connectNav.viewControllers.first! as! ConnectViewController
      connect.bindViewModel(to: viewModels.connect)
      
      var profile = tabbar.viewControllers![4] as! ProfileViewController
      profile.bindViewModel(to: viewModels.profile)
      
      

      return tabbar
    }
  }
}
