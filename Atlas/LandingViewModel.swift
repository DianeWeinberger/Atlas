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
import Lock
import SimpleKeychain


class LandingViewModel  {
  var coordinator: CoordinatorType
  
  // MARK: Input
  
  // MARK: Output
  
  // MARK: Action
  lazy var logInAction: Action<Void, Void> = {
    return Action { _ in
//      Auth0
//        .webAuth()
//        .audience("https://abeer.auth0.com/userinfo")
//        .start {
//          switch $0 {
//          case .failure(let error):
//            // Handle the error
//            print("Error: \(error)")
//          case .success(let credentials):
//            // Do something with credentials e.g.: save them.
//            // Auth0 will automatically dismiss the hosted login page
//            print("Credentials: \(credentials)")
//          }
//      }
    
      Lock
        .classic()
        .withOptions {
          $0.oidcConformant = true
        }
        .withStyle {
          $0.headerColor = Colors.orange
          $0.title = "Atlas"
          $0.titleColor = UIColor.white
          $0.primaryColor = UIColor.purple
        }
        // withConnections, withOptions, withStyle, etc
        .onAuth { credentials in
          guard let accessToken = credentials.accessToken, let refreshToken = credentials.refreshToken else { return }
          let keychain = A0SimpleKeychain(service: "Auth0")
          keychain.setString(accessToken, forKey: "access_token")
          keychain.setString(refreshToken, forKey: "refresh_token")
        }
        .present(from: self.coordinator.currentViewController)
      
//      let vm = LogInViewModel(coordinator: self.coordinator)
//      self.coordinator.transition(to: AuthScene.login(vm), type: TransitionType.push)
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
