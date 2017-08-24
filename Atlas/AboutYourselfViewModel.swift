//
//  AboutYourselfViewModel.swift
//  Atlas
//
//  Created by Magfurul Abeer on 8/24/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import Foundation
import RxSwift
import Action

class AboutYourselfViewModel  {
  var coordinator: CoordinatorType
  
  // MARK: Input
  
  // MARK: Output
  
  // MARK: Action
  lazy var nextAction: Action<Void, Void> = {
    return Action { _ in
      let vm = LogInViewModel(coordinator: self.coordinator)
      self.coordinator.transition(to: AuthScene.login(vm), type: TransitionType.root)
      return Observable.empty()
    }
  }()
  
  lazy var skipAction: Action<Void, Void> = {
    return Action { _ in
      // DRY this out
      let homeViewModel = HomeViewModel(coordinator: self.coordinator)
      let connectViewModel = ConnectViewModel(coordinator: self.coordinator)
      let profileViewModel = ProfileViewModel(coordinator: self.coordinator)
      let tabbarViewModel = AtlasTabBarViewModel(coordinator: self.coordinator)
      let viewModels: MainViewModels = (tabbarViewModel, homeViewModel, connectViewModel, profileViewModel)
      
      let mainScene = MainScene.main(viewModels)
      self.coordinator.transition(to: mainScene, type: .root)
      return Observable.empty()
    }
  }()
  
  init(coordinator: CoordinatorType) {
    self.coordinator = coordinator
  }
}
