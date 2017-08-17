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
import AWSCognitoIdentityProvider
import Dotzu

class SignUpViewModel  {
  var coordinator: CoordinatorType
  
  // MARK: Input
  var firstName = PublishSubject<String>()
  var lastName = PublishSubject<String>()
  var email = PublishSubject<String>()
  var password = PublishSubject<String>()
  
  // MARK: Output
  
  // MARK: Actions
    
//  lazy var signUpButtonTapped: CocoaAction = { _ in
//    let action = CocoaAction { _ in
//      print("COCOA ACTION START")
//      return self.signUpData
//        .debug("Sign_Up_Data")
//        .flatMap { Observable.combineLatest(AuthService.signUp(data: $0), Observable.of($0)) }
//        .debug("Sign_Up_Response")
//        .flatMap { AuthService.signIn(user: $0.user, email: $1.email, password: $1.password) }
//        .debug("Log_In_Session")
//        .flatMap { _ in self.userDidSignUp() }
//        .debug("Transition")
//        .catchError { e -> Observable<Void> in
//          print(e.localizedDescription)
//          self.coordinator.currentViewController.error(e)
//          return Observable.empty()
//        }
//    }
//    
//    return CocoaAction { _ in
//      action.execute()
//      return Observable.empty()
//    }
//  }()

//  var signUpButtonTapped = Action<SignUpCredentials, AWSCognitoIdentityUserPoolSignUpResponse> { credentials in
//    return AuthService.signUp(data: credentials)
//  }
  
//  lazy var userDidSignUp: Observable<Void> = { _ in
//    self.signUpButtonTapped.elements
//      .takeLast(1)
//    return Observable.empty()
//  }()
  
  // MARK: Private Observables
  lazy var signUpData: Observable<SignUpCredentials> = {
    return Observable
      .combineLatest(self.firstName, self.lastName, self.email, self.password) { ($0, $1, $2, $3) }
  }()
  
  // TODO: DRY this out. Used in many places
  @discardableResult
  func transitionToTabbar() -> Observable<Void> {
    let homeViewModel = HomeViewModel(coordinator: coordinator)
    let connectViewModel = ConnectViewModel(coordinator: coordinator)
    let profileViewModel = ProfileViewModel(coordinator: coordinator)
    let tabbarViewModel = AtlasTabBarViewModel(coordinator: coordinator)
    let viewModels: MainViewModels = (tabbarViewModel, homeViewModel, connectViewModel, profileViewModel)
    
    let mainScene = MainScene.main(viewModels)
    
    return coordinator.transition(to: mainScene, type: TransitionType.root)
  }
  
  init(coordinator: CoordinatorType) {
    self.coordinator = coordinator
  }
}
