//
//  Error.swift
//  Atlas
//
//  Created by Magfurul Abeer on 8/23/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import Foundation

extension Error {
  var message: String {
    let err = self as NSError
    
    if let msg = err.userInfo["message"] as? String{
      return msg
    }
    
    return self.localizedDescription
  }
}
