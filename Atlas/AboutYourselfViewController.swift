//
//  AboutYourselfViewController.swift
//  Atlas
//
//  Created by Magfurul Abeer on 8/24/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import UIKit
import RxKeyboard

class AboutYourselfViewController: UIViewController {

  @IBOutlet weak var nextButton: UIButton!
  @IBOutlet weak var skipButton: UIButton!
  @IBOutlet weak var weightTextField: UITextField!
  @IBOutlet weak var heightTextField: UITextField!
  @IBOutlet weak var genderTextField: UITextField!
  
  var viewModel: AboutYourselfViewModel!

  override func viewDidLoad() {
    super.viewDidLoad()
    setUpOnTapDismiss()
  }
}


extension AboutYourselfViewController: BindableType {
  func bindViewModel() {
    nextButton.rx.action = viewModel.nextAction
    skipButton.rx.action = viewModel.skipAction
  }
}
