//
//  SignUpViewController.swift
//  Atlas
//
//  Created by Magfurul Abeer on 7/25/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import UIKit
import RxSwift
import RxSwiftExt
import Action
import AWSCognitoIdentityProvider
import Dotzu
import RxKeyboard

class SignUpViewController: UIViewController {
  
  @IBOutlet weak var firstNameTextField: UITextField!
  @IBOutlet weak var lastNameTextField: UITextField!
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var signUpButton: UIButton!
  @IBOutlet weak var backButton: UIButton!
  
  var viewModel: SignUpViewModel!

  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationController?.setNavigationBarHidden(false, animated: false)
    
    backButton.rx.action = viewModel.backAction

    setUpOnTapDismiss()
    
    // TODO: Clean up and move to viewModel
    signUpButton.rx.tap
      
      // MARK: Signup
      .withLatestFrom(viewModel.signUpData)
      .flatMap { Observable.combineLatest(AuthService.shared.signUp(data: $0), Observable.of($0)) }
      
      // MARK: Login
      .withLatestFrom(viewModel.signUpData)
      .flatMap { data -> Observable<AWSCognitoIdentityUserSession> in
        return AuthService.shared.signIn(email: data.email, password: data.password)
      }
      .map { _ in true }
      .catchError { e -> Observable<Bool> in
        print(e.message)
        OperationQueue.main.addOperation { self.awsError(e) }
        return Observable.just(false)
      }
      .filter { $0 }
      
      // MARK: Get sub value
      .flatMap { _ -> Observable<AWSCognitoIdentityUserGetDetailsResponse> in
        return AuthService.shared.currentUserDetails()
      }
      .map { details -> String in
        guard let attributes = details.userAttributes else {
          throw AuthServiceError.userAttributesDoesNotExist
        }
        
        // TODO: Handle this when it's either this or attributes dont exist
        guard let sub = attributes.filter({ $0.name == "sub" }).first?.value else {
          throw AuthServiceError.userHasNoSubValue
        }
        
        UserDefaults.standard.setValue(sub, forKey: "currentUserId")
        return sub
      }
      
      // MARK: Create and save user
      .withLatestFrom(viewModel.signUpData, resultSelector: { (sub, data) -> (String, SignUpCredentials) in
        return (sub, data)
      })
      .flatMap { UserService.shared.createUser(id: $0, credentials: $1) }
      .map { User.deserialize($0) }
      
      // MARK: Subscribe
      .subscribeOn(MainScheduler.instance)
      .subscribe(
        onNext: { _ in
          OperationQueue.main.addOperation { self.viewModel.transitionToOnboarding() }
        },
        onError: { err in
          CognitoStore.sharedInstance.currentUser?.signOut()
          CognitoStore.sharedInstance.userPool.clearAll()
        })
      .addDisposableTo(rx_disposeBag)
  
  }
  
  func toggleTextFieldEnabled(_ enabled: Bool) {
    [firstNameTextField, lastNameTextField, emailTextField, passwordTextField]
      .forEach { $0?.isEnabled = enabled }
  }
}

extension SignUpViewController: BindableType {
  func bindViewModel() {
    firstNameTextField.rx.text.unwrap()
      .bind(to: viewModel.firstName)
      .addDisposableTo(rx_disposeBag)
    
    lastNameTextField.rx.text.unwrap()
      .bind(to: viewModel.lastName)
      .addDisposableTo(rx_disposeBag)
    
    emailTextField.rx.text.unwrap()
      .bind(to: viewModel.email)
      .addDisposableTo(rx_disposeBag)
    
    passwordTextField.rx.text.unwrap()
      .bind(to: viewModel.password)
      .addDisposableTo(rx_disposeBag)
  }
}
