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
    self.navigationController?.setNavigationBarHidden(false, animated: false)

    let logInData = Observable.combineLatest(
      emailTextField.rx.text.map { $0 ?? "" },
      passwordTextField.rx.text.map { $0 ?? "" }
    )
    
    // TODO: Clean up and move to viewModel
    logInButton.rx.tap.asObservable()
      
      // MARK: Login
      .withLatestFrom(logInData)
      .debug("Log_In_Data")
      .flatMap { email, password -> Observable<AWSCognitoIdentityUserSession> in
        return AuthService.shared.signIn(email: email, password: password)
      }
      .debug("Log_In_Session")
      .map { _ in true }
      .catchError { e -> Observable<Bool> in
        print(e.localizedDescription)
        OperationQueue.main.addOperation { self.error(e) }
        return Observable.just(false)
      }
      .filter { $0 }
      
      // MARK: Create and Save
      .withLatestFrom(logInData)
      .flatMap { UserService.shared.getUser(id: $0.0) }
      .debug("Created_User")
      .map { User.deserialize($0) }
      .debug("Realm_User")
      
      // Mark: SUBSCRIBE
      .subscribe(onNext: { user in
          OperationQueue.main.addOperation {
            self.viewModel.userDidLogIn()
          }
      })
      .addDisposableTo(rx_disposeBag)    
  }
  
  func bindViewModel() {
    
  }
  
  @IBAction func loginButton(_ sender: UIButton) {

  }
}
