//
//  AuthScene.swift
//  Atlas
//
//  Created by Magfurul Abeer on 7/19/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import UIKit

enum AuthScene: SceneType {
  case landing(LandingViewModel)
  case login(LogInViewModel)
  case signup(SignUpViewModel)
}

extension AuthScene {
  var viewController: UIViewController {
    let storyboard = UIStoryboard(name: "Auth", bundle: nil)
    
    switch self {
    case .landing(let viewModel):
      let navController = storyboard.instantiateViewController(withIdentifier: "landing") as! UINavigationController
      var viewController = navController.viewControllers.first as! LandingViewController
      viewController.bindViewModel(to: viewModel)
      return navController
      
    case .login(let viewModel):
      var viewController = storyboard.instantiateViewController(withIdentifier: "login") as! LogInViewController
      viewController.bindViewModel(to: viewModel)
      return viewController
      
    case .signup(let viewModel):
      var viewController = storyboard.instantiateViewController(withIdentifier: "signup") as! SignUpViewController
      viewController.bindViewModel(to: viewModel)
      return viewController
    }
    
  }
}
