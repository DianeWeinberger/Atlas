//
//  LogInViewController.swift
//  Atlas
//
//  Created by Magfurul Abeer on 7/25/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import UIKit


class LogInViewController: UIViewController, BindableType {

  
  @IBOutlet weak var emailTextField: UITextField!
  @IBOutlet weak var passwordTextField: UITextField!
  
  var viewModel: LogInViewModel!

  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = UIColor.purple
  }
  
  func bindViewModel() {
    
  }
  
  @IBAction func loginButton(_ sender: UIButton) {

  }
}
