//
//  SettingsViewModel.swift
//  Atlas
//
//  Created by Magfurul Abeer on 8/25/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import Foundation
import RxSwift
import Action
import AWSCognitoIdentityProvider
import RealmSwift

protocol SettingsViewModelInputsType {
}

protocol SettingsViewModelOutputsType {
}

protocol SettingsViewModelActionsType {
  var backAction: CocoaAction { get }
  var logOutAction: CocoaAction { get }
  var saveAction: CocoaAction { get }
}

protocol SettingsViewModelType {
  var inputs: ConnectViewModelInputsType { get }
  var outputs: ConnectViewModelOutputsType { get }
  var actions: ConnectViewModelActionsType { get }
  var coordinator: CoordinatorType { get set }
}


class SettingsViewModel  {
  var coordinator: CoordinatorType
  
  // MARK: Input
  
  // MARK: Output
  var user: User {
    do {
      return try Realm.currentUser()
    } catch {
//      logOutAction.execute()
      return User()
    }
  }
  
  // MARK: Actions
  lazy var backAction: CocoaAction = {
    return Action { _ in
      self.coordinator.pop()
      return Observable.empty()
    }
  }()
  
  lazy var saveAction: CocoaAction = {
    return Action { _ in
      self.coordinator.pop()
      return Observable.empty()
    }
  }()
  
  lazy var logOutAction: CocoaAction = {
    return Action { _ in
      AuthService.shared.logOut()
      Realm.clear()
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

extension SettingsViewModel: SettingsViewModelInputsType, SettingsViewModelOutputsType, SettingsViewModelActionsType { }
