//
//  AtlasTabBarViewModel.swift
//  Atlas
//
//  Created by Magfurul Abeer on 7/20/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import Foundation

struct AtlasTabBarViewModel  {
  var coordinator: CoordinatorType
  
  // MARK: Input
  
  // MARK: Output
  
  init(coordinator: CoordinatorType) {
    self.coordinator = coordinator
  }
  
  func didSelectRunTabBarItem() {
    print("DID SELECT")
    let runViewModel = RunViewModel(coordinator: coordinator)
    coordinator.transition(to: RunScene.run(runViewModel), type: .modal)
  }
}
