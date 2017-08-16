//
//  ProfileViewModel.swift
//  Atlas
//
//  Created by Magfurul Abeer on 8/15/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import Foundation
import RxSwift
import Action

class ProfileViewModel  {
  var coordinator: CoordinatorType
  
  // MARK: Input
  
  // MARK: Output
  
  // MARK: Actions
  lazy var logOutAction: CocoaAction = {
    return Action { _ in
      AuthService.logOut()
      self.goToLandingScreen()
      return Observable.empty()
    }
  }()
  
  
  func goToLandingScreen() {
    // TODO: DRY this out
    let landingViewModel = LandingViewModel(coordinator: coordinator)
    let landingScene = AuthScene.landing(landingViewModel)
    coordinator.transition(to: landingScene, type: .root)
  }
  
  init(coordinator: CoordinatorType) {
    self.coordinator = coordinator
  }
}
