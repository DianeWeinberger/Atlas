//
//  GetStartedViewController.swift
//  Atlas
//
//  Created by Magfurul Abeer on 8/24/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import UIKit

class GetStartedViewController: UIViewController, BindableType {

  @IBOutlet weak var letsBeginButton: UIButton!
  var viewModel: GetStartedViewModel!

  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  func bindViewModel() {
    letsBeginButton.rx.action = viewModel.letsBeginAction
  }
}
