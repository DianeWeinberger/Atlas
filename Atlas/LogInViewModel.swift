//
//  LogInViewModel.swift
//  Atlas
//
//  Created by Magfurul Abeer on 7/25/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import Foundation
import RxSwift
import Action

class LogInViewModel  {
  var coordinator: CoordinatorType
  
  // MARK: Input
  
  // MARK: Output
  func userDidLogIn() {
    // TODO: Dry this out
    let homeViewModel = HomeViewModel(coordinator: coordinator)
    let connectViewModel = ConnectViewModel(coordinator: coordinator)
    let tabbarViewModel = AtlasTabBarViewModel(coordinator: coordinator)
    let profileViewModel = ProfileViewModel(coordinator: coordinator)
    let viewModels: MainViewModels = (tabbarViewModel, homeViewModel, connectViewModel, profileViewModel)
    
    let mainScene = MainScene.main(viewModels)
    
    coordinator.transition(to: mainScene, type: TransitionType.root)
  }
  
  // MARK: Action
  lazy var backAction: Action<Void, Void> = {
    return Action { _ in
      self.coordinator.pop()
      return Observable.empty()
    }
  }()
  
  init(coordinator: CoordinatorType) {
    self.coordinator = coordinator
  }
}
