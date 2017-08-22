//
//  AWSConstants.swift
//  Atlas
//
//  Created by Magfurul Abeer on 8/11/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import Foundation
import AWSCore

struct Constants {
  struct API {
    static let baseURL = ProcessInfo.processInfo.environment["BASE_URL"] ?? ""
  }
  
  struct AWS {
    static let clientId = ProcessInfo.processInfo.environment["APP_CLIENT_ID"] ?? ""
    static let clientSecret = ProcessInfo.processInfo.environment["APP_CLIENT_SECRET"] ?? ""
    static let poolId = ProcessInfo.processInfo.environment["USER_POOL_ID"] ?? ""
    static let identityPoolId = ProcessInfo.processInfo.environment["IDENTITY_POOL_ID"] ?? ""
    static let userPoolKey = "UserPool"
    static let region = AWSRegionType.USEast2
  }
}
