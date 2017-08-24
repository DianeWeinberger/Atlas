//
//  AboutYourselfViewController.swift
//  Atlas
//
//  Created by Magfurul Abeer on 8/24/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import UIKit
import RxKeyboard

class AboutYourselfViewController: UIViewController, BindableType {

  @IBOutlet weak var nextButton: UIButton!
  @IBOutlet weak var skipButton: UIButton!
  @IBOutlet weak var weightTextField: UITextField!
  @IBOutlet weak var heightTextField: UITextField!
  @IBOutlet weak var genderTextField: UITextField!
  
  
  var viewModel: AboutYourselfViewModel!

  override func viewDidLoad() {
    super.viewDidLoad()
    
    setUpKeyboardDismissOnTap()
    
    RxKeyboard.instance.visibleHeight
      .drive(onNext: { height in
        print(height)
        let skipFrame = self.skipButton.frame
        let skipBottom = skipFrame.origin.y + skipFrame.size.height
        
        let displacement = height - skipBottom
        print(displacement)
        self.view.transform = CGAffineTransform.init(translationX: 0, y: -displacement)
      })
      .addDisposableTo(rx_disposeBag)
  }
  
  func bindViewModel() {
    nextButton.rx.action = viewModel.nextAction
    skipButton.rx.action = viewModel.skipAction
  }
}
