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
  @IBOutlet weak var noAccountLabel: UILabel!
  
  var viewModel: LandingViewModel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.navigationController?.navigationBar.isHidden = true    
    
    
    logInButton.rx.action = viewModel.logInAction
    signUpButton.rx.action = viewModel.signUpAction
  }
  
  func fadeInAnimation() {
    logInButton.isHidden = true
    signUpButton.isHidden = true
    noAccountLabel.isHidden = true
    
    UIView.animate(withDuration: 0.5) { 
      self.logInButton.isHidden = false
      self.signUpButton.isHidden = false
      self.noAccountLabel.isHidden = false
    }
  }
  
}
