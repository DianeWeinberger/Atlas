//
//  AtlasTabBarViewModel.swift
//  Atlas
//
//  Created by Magfurul Abeer on 7/20/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import Foundation
import RxSwift

protocol AtlasTabBarViewModelInputsType { }

protocol AtlasTabBarViewModelOutputsType { }

protocol AtlasTabBarViewModelActionsType { }

protocol AtlasTabBarViewModelType {
  var inputs: AtlasTabBarViewModelInputsType { get }
  var outputs: AtlasTabBarViewModelOutputsType { get }
  var actions: AtlasTabBarViewModelActionsType { get }
  var coordinator: CoordinatorType { get set }
}

final class AtlasTabBarViewModel: AtlasTabBarViewModelType  {
  
  var inputs: AtlasTabBarViewModelInputsType { return self }
  var outputs: AtlasTabBarViewModelOutputsType { return self }
  var actions: AtlasTabBarViewModelActionsType { return self }
  var coordinator: CoordinatorType
  
  // MARK: Input
  
  // MARK: Output
  
  init(coordinator: CoordinatorType) {
    self.coordinator = coordinator
  }
  
  func didSelectRunTabBarItem() {
    let runViewModel = RunViewModel(coordinator: coordinator)
    coordinator.transition(to: RunScene.run(runViewModel), type: .modal)
  }
}


extension AtlasTabBarViewModel: AtlasTabBarViewModelInputsType, AtlasTabBarViewModelOutputsType, AtlasTabBarViewModelActionsType { }
