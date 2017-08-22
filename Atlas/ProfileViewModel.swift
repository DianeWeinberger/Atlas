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

protocol ProfileViewModelInputsType {
}

protocol ProfileViewModelOutputsType {
}

protocol ProfileViewModelActionsType {
  var logOutAction: CocoaAction { get }
}

protocol ProfileViewModelType {
  var inputs: ConnectViewModelInputsType { get }
  var outputs: ConnectViewModelOutputsType { get }
  var actions: ConnectViewModelActionsType { get }
  var coordinator: CoordinatorType { get set }
}


class ProfileViewModel  {
  var coordinator: CoordinatorType
  
  // MARK: Input
  
  // MARK: Output
  
  // MARK: Actions
  lazy var logOutAction: CocoaAction = {
    return Action { _ in
      AuthService.shared.logOut()
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

extension ProfileViewModel: ProfileViewModelInputsType, ProfileViewModelOutputsType, ProfileViewModelActionsType { }
