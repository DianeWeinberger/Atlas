//
//  TwicketSegmentedControl+Rx.swift
//  Atlas
//
//  Created by Magfurul Abeer on 7/28/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

//import UIKit
//import RxSwift
//import RxCocoa
//import TwicketSegmentedControl
//
//class RxTwicketSegmentedControlDelegateProxy: DelegateProxy, TwicketSegmentedControlDelegate, DelegateProxyType {
//  class func currentDelegateFor(_ object: AnyObject) -> AnyObject? {
//    let segmentedControl: TwicketSegmentedControl = (object as? TwicketSegmentedControl)!
//    return segmentedControl.delegate
//  }
//  
//  class func setCurrentDelegate(_ delegate: AnyObject?, toObject object:
//    AnyObject) {
//    let segmentedControl: TwicketSegmentedControl = (object as? TwicketSegmentedControl)!
//    segmentedControl.delegate = delegate as? TwicketSegmentedControlDelegate
//  }
//  
//  func didSelect(_ segmentIndex: Int) {
//    print("did select \(segmentIndex)")
//    
//    // Use Observable variable instead
//  }
//}
//
//extension Reactive where Base: TwicketSegmentedControl {
//  var delegate: DelegateProxy {
//    return RxTwicketSegmentedControlDelegateProxy.proxyForObject(base)
//  }
//  
//  var didSelect: Observable<Int> {
//    return delegate.methodInvoked(#selector(TwicketSegmentedControlDelegate.didSelect(_:)))
//      .map { parameters in
//          return parameters[0] as! Int
//      }
//  }
//}

