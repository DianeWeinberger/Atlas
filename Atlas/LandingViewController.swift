//
//  LandingViewController.swift
//  Atlas
//
//  Created by Magfurul Abeer on 7/19/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import UIKit

class LandingViewController: UIViewController, BindableType {
  
  @IBOutlet weak var logInButton: UIButton!
  @IBOutlet weak var signUpButton: UIButton!
  
  var viewModel: LandingViewModel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationController?.setNavigationBarHidden(true, animated: false)
    view.backgroundColor = UIColor(191, 104, 135)
    
    
    logInButton.rx.action = viewModel.logInAction
    signUpButton.rx.action = viewModel.signUpAction
  }
  
  func bindViewModel() {
    
  }
  
}
