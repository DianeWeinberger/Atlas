//
//  LogInViewController.swift
//  Atlas
//
//  Created by Magfurul Abeer on 7/25/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import UIKit
import AWSCognitoAuth


class LogInViewController: UIViewController, BindableType {

  
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  
  var viewModel: LogInViewModel!
  var auth: AWSCognitoAuth = AWSCognitoAuth.default()
  var session: AWSCognitoAuthUserSession?
  var firstLoad: Bool = true
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = UIColor.purple
    self.auth.delegate = self;
    if(self.auth.authConfiguration.appClientId.contains("5bv31hua2qprvvvo2u9o76t97b")){
      self.alertWithTitle("Error", message: "Info.plist missing necessary config under AWS->CognitoUserPool->Default")
    }
  }
  
  func bindViewModel() {
    
  }
  
  @IBAction func loginButton(_ sender: UIButton) {
    self.auth.getSession  { (session:AWSCognitoAuthUserSession?, error:Error?) in
      if(error != nil) {
        self.session = nil
        self.alertWithTitle("Error", message: (error! as NSError).userInfo["error"] as? String)
      }else {
        self.session = session
        self.alertWithTitle("Success", message: "You logged in as \(session?.username)")
      }
//      self.refresh()
    }
  }

  func alertWithTitle(_ title:String, message:String?) -> Void {
    DispatchQueue.main.async {
      let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
      let action = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default) { (UIAlertAction) in
        alert.dismiss(animated: false, completion: nil)
      }
      alert.addAction(action)
      self.present(alert, animated: true, completion: nil)
    }
  }
}


extension LogInViewController: AWSCognitoAuthDelegate {
  func getViewController() -> UIViewController {
    return self;
  }
}
