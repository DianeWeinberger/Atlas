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
        print(e.message)
        OperationQueue.main.addOperation { self.awsError(e) }
        return Observable.just(false)
      }
      .filter { $0 }
      
      // MARK: Get Sub
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
      .debug("Get_Details")
      
      // MARK: Get and Save User
      .flatMap { UserService.shared.getUser(id: $0) }
      .debug("Get_User")
      .map { User.deserialize($0) }
      .debug("Realm_User")

    
       //Mark: SUBSCRIBE
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
