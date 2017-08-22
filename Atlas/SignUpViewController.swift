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

class SignUpViewController: UIViewController {
  
  @IBOutlet weak var firstNameTextField: UITextField!
  @IBOutlet weak var lastNameTextField: UITextField!
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var signUpButton: UIButton!
  
  var viewModel: SignUpViewModel!

  override func viewDidLoad() {
    super.viewDidLoad()
    
    // TODO: Clean up and move to viewModel
    signUpButton.rx.tap
      .withLatestFrom(viewModel.signUpData)
      .flatMap { Observable.combineLatest(AuthService.shared.signUp(data: $0), Observable.of($0)) }
      .flatMap { UserService.shared.createUser(id: $0.user.username!, credentials: $1) }
      .map { User.deserialize($0) }
      .withLatestFrom(viewModel.signUpData)
      .flatMap { data -> Observable<AWSCognitoIdentityUserSession> in
        return AuthService.shared.signIn(email: data.email, password: data.password)
      }
      .map { _ in true }
      .catchError { e -> Observable<Bool> in
        print(e.localizedDescription)
        OperationQueue.main.addOperation { self.error(e) }
        return Observable.just(false)
      }
      .subscribeOn(MainScheduler.instance)
      .subscribe(onNext: { success in
        if success {
          OperationQueue.main.addOperation { self.viewModel.transitionToTabbar() }
        }
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
