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

class SignUpViewController: UIViewController {
  
  @IBOutlet weak var firstNameTextField: UITextField!
  @IBOutlet weak var lastNameTextField: UITextField!
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var signUpButton: UIButton!
  
  var viewModel: SignUpViewModel!

  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationController?.setNavigationBarHidden(false, animated: false)

    
    // TODO: Clean up and move to viewModel
    signUpButton.rx.tap
      
      // MARK: Signup
      .withLatestFrom(viewModel.signUpData)
      .debug("Sign_Up_Data")
      .flatMap { Observable.combineLatest(AuthService.shared.signUp(data: $0), Observable.of($0)) }
      .debug("Sign_Up_Response")
      
      // MARK: Login
      .withLatestFrom(viewModel.signUpData)
      .debug("Sign_Up_Data")
      .flatMap { data -> Observable<AWSCognitoIdentityUserSession> in
        return AuthService.shared.signIn(email: data.email, password: data.password)
      }
      .debug("Log_In_Session")
      .map { _ in true }
      .catchError { e -> Observable<Bool> in
        print(e.localizedDescription)
        OperationQueue.main.addOperation { self.error(e) }
        return Observable.just(false)
      }
      .filter { $0 }
      
      // MARK: Create and save
      .withLatestFrom(viewModel.signUpData)
      .flatMap { UserService.shared.createUser(id: $0.email, credentials: $0) }
      .debug("Created_User")
      .map { User.deserialize($0) }
      .debug("Realm_User")
      
      // MARK: Subscribe
      .subscribeOn(MainScheduler.instance)
      .subscribe(onNext: { _ in
        
        OperationQueue.main.addOperation { self.viewModel.transitionToTabbar() }

        
      })
      .addDisposableTo(rx_disposeBag)
    
//    signUpButton.rx.tap
//      .withLatestFrom(viewModel.signUpData)
//      .flatMap { Observable.combineLatest(AuthService.shared.signUp(data: $0), Observable.of($0)) }
//      .flatMap { response, data -> Observable<(JSONDictionary, SignUpCredentials)> in
//        //        guard let username = response.user.username else { throw AuthServiceError.signUpFailed }
//        let username = response.user.username!
//        return (UserService.shared.createUser(id: username, credentials: data), data)
//      }
//      .map { (User.deserialize(from: $0), $1.password) }
//      .flatMap { (user, password) -> Observable<AWSCognitoIdentityUserSession> in
//        return AuthService.shared.signIn(email: user.email, password: password)
//      }
//      .map { _ in true }
//      .catchError { e -> Observable<Bool> in
//        print(e.localizedDescription)
//        OperationQueue.main.addOperation { self.error(e) }
//        return Observable.just(false)
//      }
//      .subscribeOn(MainScheduler.instance)
//      .subscribe(onNext: { success in
//        if success {
//          OperationQueue.main.addOperation { self.viewModel.transitionToTabbar() }
//        }
//      })
//      .addDisposableTo(rx_disposeBag)
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
