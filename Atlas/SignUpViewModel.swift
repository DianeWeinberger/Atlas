//
//  SignUpViewModel.swift
//  Atlas
//
//  Created by Magfurul Abeer on 7/25/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import Foundation
import RxSwift
import Action

struct SignUpViewModel  {
  var coordinator: CoordinatorType
  
  // MARK: Input
  
  // MARK: Output
  typealias SignUpCredentials = (firstName: String, email: String, password: String)

  
  func signUp(data: SignUpCredentials) {
    
  }
  
  func userDidSignUp() {
    let homeViewModel = HomeViewModel(coordinator: coordinator)
    let connectViewModel = ConnectViewModel(coordinator: coordinator)
    let profileViewModel = ProfileViewModel(coordinator: coordinator)
    let tabbarViewModel = AtlasTabBarViewModel(coordinator: coordinator)
    let viewModels: MainViewModels = (tabbarViewModel, homeViewModel, connectViewModel, profileViewModel)
    
    let mainScene = MainScene.main(viewModels)
    
    coordinator.transition(to: mainScene, type: TransitionType.root)
  }
  
  init(coordinator: CoordinatorType) {
    self.coordinator = coordinator
  }
}
