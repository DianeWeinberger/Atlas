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
    
    logInButton.rx.tap.asObservable()
      .withLatestFrom(logInData)
      .flatMap { email, password -> Observable<AWSCognitoIdentityUserSession> in
        return AuthService.shared.signIn(email: email, password: password)
      }
      .map { session -> AWSCognitoIdentityUserSession? in
        return session
      }
      .catchError({ (err) -> Observable<AWSCognitoIdentityUserSession?> in
        print(err.localizedDescription)
        self.alert("ERROR", message: err.localizedDescription)
        return Observable.just(nil)
      })
      .filter { $0 != nil }
      .withLatestFrom(logInData)
      .map { email, password -> String in
        return AWSCognitoIdentityUser().username ?? ""
      }
      .flatMap { id in
        return UserService.shared.getUser(id: id)
      }
      .map { User.deserialize($0) }
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
