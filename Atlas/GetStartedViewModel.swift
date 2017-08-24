//
//  GetStartedViewModel.swift
//  Atlas
//
//  Created by Magfurul Abeer on 8/24/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import Foundation
import RxSwift
import Action

class GetStartedViewModel  {
  var coordinator: CoordinatorType
  
  // MARK: Input
  
  // MARK: Output
  
  // MARK: Action
  lazy var letsBeginAction: Action<Void, Void> = {
    return Action { _ in
      let vm = AboutYourselfViewModel(coordinator: self.coordinator)
      self.coordinator.transition(to: OnboardingScene.aboutYourself(vm), type: TransitionType.root)
      return Observable.empty()
    }
  }()
  

  init(coordinator: CoordinatorType) {
    self.coordinator = coordinator
  }
}
