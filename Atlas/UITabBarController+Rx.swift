//
//  UITabBarController+Rx.swift
//  Atlas
//
//  Created by Magfurul Abeer on 7/20/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class RxUITabBarControllerDelegateProxy: DelegateProxy, UITabBarControllerDelegate, DelegateProxyType {
  class func currentDelegateFor(_ object: AnyObject) -> AnyObject? {
    let tabBarController: UITabBarController = (object as? UITabBarController)!
    return tabBarController.delegate
  }
  
  class func setCurrentDelegate(_ delegate: AnyObject?, toObject object:
    AnyObject) {
    let tabBarController: UITabBarController = (object as? UITabBarController)!
    tabBarController.delegate = delegate as? UITabBarControllerDelegate
  }
}

extension Reactive where Base: UITabBarController {
  public func setDelegate(_ delegate: UITabBarControllerDelegate) -> Disposable {
    return RxUITabBarControllerDelegateProxy.installForwardDelegate(
      delegate,
      retainDelegate: false,
      onProxyForObject: self.base
    )
  }
}
