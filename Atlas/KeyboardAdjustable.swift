//
//  KeyboardAdjustable.swift
//  Atlas
//
//  Created by Magfurul Abeer on 8/25/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import Foundation
import RxSwift
import RxKeyboard

protocol KeyboardAdjustable {
  var adjustableTrigger: UIView { get }
  func setUpKeyboardAdjustable()
  func setUpKeyboardDismissOnTap()
}

extension KeyboardAdjustable where Self: UIViewController {
  func setUpKeyboardDismissOnTap() {
    self.view.rx.tapGesture()
      .withLatestFrom(RxKeyboard.instance.visibleHeight)
      .filter { _ in self.view.transform != CGAffineTransform.identity }
      .subscribe(onNext: { _ in
        self.view.endEditing(true)
      })
      .addDisposableTo(rx_disposeBag)
  }
  
  func setUpKeyboardAvoiding() {
    RxKeyboard.instance.visibleHeight
      .drive(onNext: { height in
        let triggerFrame = self.adjustableTrigger.frame
        let triggerBottom = triggerFrame.origin.y + triggerFrame.size.height

        let displacement = height - triggerBottom
        
//        if displacement > 0 {
          self.view.transform = CGAffineTransform.init(translationX: 0, y: -displacement)
//        }
      })
      .addDisposableTo(self.rx_disposeBag)
  }
  
  func setUpKeyboardAdjustable() {
    setUpKeyboardAvoiding()
    setUpKeyboardDismissOnTap()
  }
}
