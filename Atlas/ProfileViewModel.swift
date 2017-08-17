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
import AWSCognitoIdentityProvider

class ProfileViewModel  {
  var coordinator: CoordinatorType
  
  // MARK: Input
  
  // MARK: Output
  var user: AWSCognitoIdentityUser {
    var currentUser = AWSCognitoIdentityUser()
    do {
      currentUser = try AuthService.user()
    } catch {
      self.goToLandingScreen()
    }
    return currentUser
  }
  
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
