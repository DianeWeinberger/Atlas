//
//  LandingViewModel.swift
//  Atlas
//
//  Created by Magfurul Abeer on 7/19/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import Foundation
import RxSwift
import Action

class LandingViewModel  {
  var coordinator: CoordinatorType
  
  // MARK: Input
  
  // MARK: Output
  
  // MARK: Action
  lazy var logInAction: Action<Void, Void> = {
    return Action { _ in
      let vm = LogInViewModel(coordinator: self.coordinator)
      self.coordinator.transition(to: AuthScene.login(vm), type: TransitionType.push)
      return Observable.empty()
    }
  }()
  
  lazy var signUpAction: Action<Void, Void> = {
    return Action { _ in
      let vm = SignUpViewModel(coordinator: self.coordinator)
      self.coordinator.transition(to: AuthScene.signup(vm), type: TransitionType.push)
      return Observable.empty()
    }
  }()
  
  init(coordinator: CoordinatorType) {
    self.coordinator = coordinator
  }
}
