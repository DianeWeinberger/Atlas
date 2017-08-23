//
//  UIViewController.swift
//  Atlas
//
//  Created by Magfurul Abeer on 8/11/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import UIKit

extension UIViewController {
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
    let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
    controller.addAction(ok)
    present(controller, animated: true, completion: completion)
  }
}

