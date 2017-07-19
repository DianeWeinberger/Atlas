//
//  Scene.swift
//  Atlas
//
//  Created by Magfurul Abeer on 7/19/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import UIKit

enum Scene {
  case landing(LandingViewModel)
}

extension Scene {
  var viewController: UIViewController {
    switch self {
    case .landing(let viewModel):
        var vc = LandingViewController()
        vc.bindViewModel(to: viewModel)
        return vc
    }
  }
}
