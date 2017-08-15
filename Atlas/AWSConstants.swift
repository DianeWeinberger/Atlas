//
//  AWSConstants.swift
//  Atlas
//
//  Created by Magfurul Abeer on 8/11/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import Foundation
import AWSCore

struct AWS {
  
  static let userPoolId: String = ProcessInfo.processInfo.environment["USER_POOL_ID"] ?? ""
  static let appClientId: String = ProcessInfo.processInfo.environment["APP_CLIENT_ID"] ?? ""
  static let identityPoolId: String = ProcessInfo.processInfo.environment["IDENTITY_POOL_ID"] ?? ""
  
  static let region: AWSRegionType = .USEast2

}
