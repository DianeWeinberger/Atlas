//
//  OnboardingScene.swift
//  Atlas
//
//  Created by Magfurul Abeer on 8/24/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import UIKit

enum OnboardingScene: SceneType {
  case getStarted(GetStartedViewModel)
  case aboutYourself(AboutYourselfViewModel)
}

extension OnboardingScene {
  var viewController: UIViewController {
    let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
    
    switch self {
    case .getStarted(let viewModel):
      var viewController = storyboard.instantiateViewController(withIdentifier: "getStarted") as! GetStartedViewController
      viewController.bindViewModel(to: viewModel)
      return viewController
      
    case .aboutYourself(let viewModel):
      var viewController = storyboard.instantiateViewController(withIdentifier: "aboutYourself") as! AboutYourselfViewController
      viewController.bindViewModel(to: viewModel)
      return viewController
    }
    
  }
}
