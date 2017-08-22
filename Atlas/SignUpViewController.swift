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
    
    signUpButton.rx.tap
      .withLatestFrom(viewModel.signUpData)
      .debug("Sign_Up_Data")
      .flatMap { Observable.combineLatest(AuthService.shared.signUp(data: $0), Observable.of($0)) }
      .debug("Sign_Up_Response")
      .flatMap { _, data -> Observable<AWSCognitoIdentityUserSession> in
        return AuthService.shared.signIn(email: data.email, password: data.password)
      }
//      .flatMap { AuthService.signIn(user: $0.user, email: $1.email, password: $1.password) }
      .debug("Log_In_Session")
      .map { _ in true }
      .catchError { e -> Observable<Bool> in
        print(e.localizedDescription)
        //        self.coordinator.currentViewController.error(e)
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
    
//    signUpButton.rx.action = viewModel.signUpButtonTapped
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
