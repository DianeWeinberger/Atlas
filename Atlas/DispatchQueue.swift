//
//  DispatchQueue.swift
//  Atlas
//
//  Created by Magfurul Abeer on 8/2/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import Foundation

// https://stackoverflow.com/questions/37886994/dispatch-once-in-swift-3
public extension DispatchQueue {
  
  private static var _onceTracker = [String]()
  
  /**
   Executes a block of code, associated with a unique token, only once.  The code is thread safe and will
   only execute the code once even in the presence of multithreaded calls.
   
   - parameter token: A unique reverse DNS style name such as com.vectorform.<name> or a GUID
   - parameter block: Block to execute once
   */
  public class func once(token: String, block:(Void)->Void) {
    objc_sync_enter(self); defer { objc_sync_exit(self) }
    
    if _onceTracker.contains(token) {
      return
    }
    
    _onceTracker.append(token)
    block()
  }
}
