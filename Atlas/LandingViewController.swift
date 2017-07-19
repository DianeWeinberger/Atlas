//
//  LandingViewController.swift
//  Atlas
//
//  Created by Magfurul Abeer on 7/19/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import UIKit

class LandingViewController: UIViewController, BindableType {
  
  var viewModel: LandingViewModel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = UIColor.purple
  }
  
  func bindViewModel() {
    
  }
  
}
