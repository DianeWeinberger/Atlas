//
//  ProfileScene.swift
//  Atlas
//
//  Created by Magfurul Abeer on 8/25/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import UIKit

enum ProfileScene: SceneType {
  case profile(ProfileViewModel)
  case setting(SettingsViewModel)
}

extension ProfileScene {
  var viewController: UIViewController {
    let storyboard = UIStoryboard(name: "Profile", bundle: nil)
    
    switch self {
    case .profile(let viewModel):
      var viewController = storyboard.instantiateInitialViewController() as! ProfileViewController
      viewController.bindViewModel(to: viewModel)
      return viewController
      
    case .setting(let viewModel):
      var viewController = storyboard.instantiateViewController(withIdentifier: "settings") as! SettingsViewController
      viewController.bindViewModel(to: viewModel)
      return viewController
    }
    
    
  }
}
