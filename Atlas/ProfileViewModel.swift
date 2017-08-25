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
import RealmSwift

protocol ProfileViewModelInputsType {
}

protocol ProfileViewModelOutputsType {
}

protocol ProfileViewModelActionsType {
  var editAction: CocoaAction { get }
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
  var user: User {
    do {
      return try Realm.currentUser()
    } catch {
//      logOutAction.execute()
      return User()
    }
  }
  
  // MARK: Actions

  
  lazy var editAction: CocoaAction = {
    return Action { _ in
      let settingsViewModel = SettingsViewModel(coordinator: self.coordinator)
      let settingsScene = ProfileScene.setting(settingsViewModel)
      self.coordinator.transition(to: settingsScene, type: .modal)
      return Observable.empty()
    }
  }()
  
  init(coordinator: CoordinatorType) {
    self.coordinator = coordinator
  }
}

extension ProfileViewModel: ProfileViewModelInputsType, ProfileViewModelOutputsType, ProfileViewModelActionsType { }
