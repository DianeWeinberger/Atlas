//
//  MainScene.swift
//  Atlas
//
//  Created by Magfurul Abeer on 7/20/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import UIKit

typealias MainViewModels = (tabbar: AtlasTabBarViewModel, run: RunViewModel)

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
      return tabbar
    }
  }
}
