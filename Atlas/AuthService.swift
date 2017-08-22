//
//  AuthService.swift
//  Atlas
//
//  Created by Magfurul Abeer on 8/10/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import Foundation
import AWSCognitoIdentityProvider
import AWSCore
import RxSwift
import RxCocoa

enum AuthServiceError: Error {
  case unknown
  case signUpFailed
  case userNotSignedIn
}

typealias SignUpCredentials = (firstName: String, lastName: String, email: String, password: String)

class AuthService {
  
  public static let shared = AuthService()
  
  let store = CognitoStore.sharedInstance
  
  func signUp(data: SignUpCredentials) -> Observable<AWSCognitoIdentityUserPoolSignUpResponse> {
    return signUp(firstName: data.firstName, lastName: data.lastName, email: data.email, password: data.password)
  }
  
  
  func signUp(firstName: String, lastName: String, email: String, password: String) -> Observable<AWSCognitoIdentityUserPoolSignUpResponse> {
    return Observable.create { observer in
      
      let attributes = self.userAttributes(firstName: firstName, lastName: lastName, email: email, password: password)
      self.store.userPool
        .signUp(email, password: password, userAttributes: attributes, validationData: nil)
        .continueWith(block: { (response) -> Any? in
          if let error = response.error {
            observer.onError(error)
          }
          
          if let result = response.result {
            observer.onNext(result)
          }
          
          observer.onCompleted()
          return Disposables.create()
          
        })
      
      
      return Disposables.create()
      }
  }
  

  func signIn(email: String, password: String) -> Observable<AWSCognitoIdentityUserSession> {
    return Observable.create { observer in

      self.store.userPool
        .getUser(email)
        .getSession(email, password: password, validationData: nil)
        .continueWith(block: { session -> Any? in
          if let error = session.error {
            observer.onError(error)
          }
          
          if let result = session.result {
            observer.onNext(result)
          }
          
          observer.onCompleted()
          return Disposables.create()
          
        })
      
      
      return Disposables.create()
    }
  }
  
  
  func logOut() {
    store.userPool
      .getUser()
      .signOut()
  }
}


extension AuthService {
  
  var isSignedIn: Bool {
    let userPool = store.userPool
    
    guard let user = userPool.currentUser() else { return false }
    return user.isSignedIn
  }
  
  fileprivate func userAttributes(firstName: String, lastName: String, email: String, password: String) -> [AWSCognitoIdentityUserAttributeType] {
    let nameAttribute = AWSCognitoIdentityUserAttributeType(name: "given_name", value: firstName)
    let emailAttribute = AWSCognitoIdentityUserAttributeType(name: "email", value: email)
    let passwordAttribute = AWSCognitoIdentityUserAttributeType(name: "family_name", value: lastName)
    return [nameAttribute, emailAttribute, passwordAttribute]
  }
}
