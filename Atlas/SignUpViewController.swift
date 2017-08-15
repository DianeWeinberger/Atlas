//
//  SignUpViewController.swift
//  Atlas
//
//  Created by Magfurul Abeer on 7/25/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import AWSCognitoIdentityProvider

class SignUpViewController: UIViewController, BindableType {

  var viewModel: SignUpViewModel!
  
  @IBOutlet weak var firstNameTextField: UITextField!
  @IBOutlet weak var lastNameTextField: UITextField!
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  
  @IBOutlet weak var signUpButton: UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    typealias SignUpCredentials = (firstName: String, lastName: String, email: String, password: String)

    
    let signUpData = Observable.combineLatest(
      firstNameTextField.rx.text.map { $0 ?? "" },
      lastNameTextField.rx.text.map { $0 ?? "" },
      emailTextField.rx.text.map { $0 ?? "" },
      passwordTextField.rx.text.map { $0 ?? "" }
    ).map { firstName, lastName, email, password -> SignUpCredentials in
      return (firstName: firstName, lastName: lastName, email: email, password: password)
    }

    signUpButton.rx.tap.asObservable()
      .withLatestFrom(signUpData)
      .flatMap { data -> Observable<(AWSCognitoIdentityUserPoolSignUpResponse, SignUpCredentials)> in
        return Observable.combineLatest(
          AuthService.signUp(firstName: data.firstName, lastName: data.lastName, email: data.email, password: data.password),
          Observable.of(data)
        )
      }
      .flatMap { response, data -> Observable<AWSCognitoIdentityUserSession> in
        return AuthService.signIn(user: response.user, email: data.email, password: data.password)
      }
      .subscribe(
        onNext: { session in
        
          print(session.accessToken,
            session.idToken,
            session.refreshToken)
          
          OperationQueue.main.addOperation {
            print("done")
            self.viewModel.userDidSignUp()
          }

      }, onError: { err in
        
        self.alert("ERROR", message: err.localizedDescription)
        
      })
    .addDisposableTo(rx_disposeBag)
    
  }
  
  func bindViewModel() {
    
  }

}
