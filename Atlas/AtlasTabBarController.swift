//
//  AtlasTabBarController.swift
//  Atlas
//
//  Created by Magfurul Abeer on 7/20/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AtlasTabBarController: UITabBarController, BindableType {
  
  var viewModel: AtlasTabBarViewModel!

  override func viewDidLoad() {
    rx.setDelegate(self).addDisposableTo(rx_disposeBag)
    
  }
  
}

extension AtlasTabBarController: UITabBarControllerDelegate {
  func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
    let selectedVC = viewControllers![2]
    
    guard viewController == selectedVC else {
      return true
    }
    
    viewModel.didSelectRunTabBarItem()
    return false
  }
}

