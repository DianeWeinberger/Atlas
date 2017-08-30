//
//  UIViewController.swift
//  Atlas
//
//  Created by Magfurul Abeer on 8/11/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import UIKit
import RxSwift
import RxKeyboard

extension UIViewController {
  static var storyboardId: String {
    return String(describing: self.self)
  }
  
  func setUpOnTapDismiss() {
    let tap = UITapGestureRecognizer(target: self, action: #selector(onTapDismissKeyboard))
    view.addGestureRecognizer(tap)
  }
  
  func onTapDismissKeyboard() {
    self.view.endEditing(true)
  }
  
  func catchError(_ err: Error) -> Observable<Bool> {
    alert("ERROR", message: err.message)
    return Observable.just(false)
  }
  
  func awsError(_ err: Error) {
    alert("ERROR", message: err.message)
  }
  
  func error(_ err: Error) {
    alert("ERROR", message: err.localizedDescription)
  }
  
  func alert(_ title: String?, message: String?) {
    OperationQueue.main.addOperation {
      let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
      let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
      controller.addAction(ok)
      self.present(controller, animated: true, completion: nil)
    }
  }
  
  func alert(_ title: String?, message: String?, _ completion: @escaping () -> Void) {
    OperationQueue.main.addOperation {
      let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
      let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
      controller.addAction(ok)
      self.present(controller, animated: true, completion: completion)
    }
  }
}

