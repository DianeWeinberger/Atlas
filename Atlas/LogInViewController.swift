//
//  LogInViewController.swift
//  Atlas
//
//  Created by Magfurul Abeer on 7/25/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import UIKit
import AWSCognitoIdentityProvider
import RxSwift

class LogInViewController: UIViewController, BindableType {

  
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  @IBOutlet weak var logInButton: UIButton!
  
  var viewModel: LogInViewModel!

  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    
    let logInData = Observable.combineLatest(
      emailTextField.rx.text.map { $0 ?? "" },
      passwordTextField.rx.text.map { $0 ?? "" }
    )
    
    logInButton.rx.tap.asObservable()
      .withLatestFrom(logInData)
      .flatMap { email, password -> Observable<AWSCognitoIdentityUserSession> in
        return AuthService.signIn(email: email, password: password)
      }.subscribe(onNext: { session in
        
        print("LOGGED IN")
        print(session.accessToken, session.idToken, session.refreshToken,  session.expirationTime)
        
        OperationQueue.main.addOperation {
          self.viewModel.userDidLogIn()
        }
      }, onError: { err in
        self.alert("ERROR", message: err.localizedDescription)
      })
      .addDisposableTo(rx_disposeBag)
    
    view.backgroundColor = UIColor.purple
  }
  
  func bindViewModel() {
    
  }
  
  @IBAction func loginButton(_ sender: UIButton) {

  }
}
