//
//  HomeScene.swift
//  Atlas
//
//  Created by Magfurul Abeer on 8/1/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import UIKit

enum HomeScene: SceneType {
  case home(HomeViewModel)
}

extension HomeScene {
  var viewController: UIViewController {
    let storyboard = UIStoryboard(name: "Home", bundle: nil)
    
    switch self {
    case .home(let viewModel):
      var viewController = storyboard.instantiateInitialViewController() as! HomeViewController
      viewController.bindViewModel(to: viewModel)
      return viewController
    }
  }
}
