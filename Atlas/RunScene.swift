//
//  RunScene.swift
//  Atlas
//
//  Created by Magfurul Abeer on 7/20/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import UIKit

enum RunScene: SceneType {
  case run(RunViewModel)
}

extension RunScene {
  var viewController: UIViewController {
    let storyboard = UIStoryboard(name: "Run", bundle: nil)
    
    switch self {
    case .run(let viewModel):
      var viewController = storyboard.instantiateInitialViewController() as! RunViewController
      viewController.bindViewModel(to: viewModel)
      return viewController
    }
  }
}
