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
  @IBOutlet weak var backButton: UIButton!
  
  var viewModel: LogInViewModel!

  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationController?.navigationBar.isHidden = false
    
    backButton.rx.action = viewModel.backAction
    setUpOnTapDismiss()

    let logInData = Observable.combineLatest(
      emailTextField.rx.text.map { $0 ?? "" },
      passwordTextField.rx.text.map { $0 ?? "" }
    )
    
    // TODO: Clean up and move to viewModel
    logInButton.rx.tap.asObservable()
      .withLatestFrom(logInData)
      .flatMap { AuthService.shared.signIn(email: $0, password: $1) }
      .map { _ in true }
      .catchError(self.catchError)
      .filter { $0 }
      .flatMap { _ in AuthService.shared.currentUserDetails() }
      .map(AuthService.shared.getUserSub)
      .flatMap(UserService.shared.getUser)
      .map(User.deserialize)
      .subscribe(
        onNext: { user in
          
          guard !user.id.isEmpty else {
            CognitoStore.sharedInstance.currentUser?.signOut()
            CognitoStore.sharedInstance.userPool.clearAll()
            return
          }
          
          OperationQueue.main.addOperation {
            self.viewModel.userDidLogIn()
          }
        },
        onError: { err in
          OperationQueue.main.addOperation {
            CognitoStore.sharedInstance.currentUser?.signOut()
            CognitoStore.sharedInstance.userPool.clearAll()
            self.awsError(err)
          }
        })
      .addDisposableTo(rx_disposeBag)
  }
  
  func bindViewModel() {
    
  }
  
  @IBAction func loginButton(_ sender: UIButton) {

  }
}
