//
//  JWToken.swift
//  BetterNetworking
//
//  Created by Damian Esteban on 3/15/17.
//  Copyright © 2017 Damian Esteban. All rights reserved.
//

import Foundation

// Date extension for comparing current date
public extension Date {
    var isInPast: Bool {
        let now = Date()
        return self.compare(now) == ComparisonResult.orderedAscending
    }
}

/// 🗄 Storage - username, token, other assorted stored things.
// TODO: (question) - Does it make more sense for this to be a class?
// TODO: - Possibly create a `StorageType` (name subject to change) protocol for `UserDefaults` and the keychain that provides an abstraction layer and allows for more flexibility, i.e. a method could write to an object that conforms to `StorageType`, not just `UserDefaults`.
public struct Storage {
    public static var token = AWSToken(defaults: UserDefaults.standard)
}

/// AWSToken
public struct AWSToken {
    
    // MARK: - UserDefaults keys
    public enum DefaultsKeys: String {
        case TokenKey = "AWSTokenKey"
        case TokenExpiry = "AWSTokenExpiry"
    }
    
    // MARK: - Initializers
    public let defaults: UserDefaults
    
    public init(defaults: UserDefaults) {
        self.defaults = defaults
    }
    
    public init() {
        self.defaults = UserDefaults.standard
    }
    
    // MARK: - Properties
    
    // The actual token
    public var tokenString: String? {
        get {
            let key = defaults.string(forKey: DefaultsKeys.TokenKey.rawValue)
            return key
        }
        set(newToken) {
            defaults.set(newToken, forKey: DefaultsKeys.TokenKey.rawValue)
        }
    }
    
    // The token's expiration date
    public var expiry: Date? {
        get {
            return defaults.object(forKey: DefaultsKeys.TokenExpiry.rawValue) as? Date
        }
        set(newExpiry) {
            defaults.set(newExpiry, forKey: DefaultsKeys.TokenExpiry.rawValue)
        }
    }
    
    // Is the token expired?
    public var expired: Bool {
        if let expiry = expiry {
            return expiry.isInPast
        }
        return false
    }
    
    // Is the token valid, i.e. is it not empty and not expired?
    public var isValid: Bool {
        if let tokenString = tokenString {
            return tokenString.isEmpty && !expired
        }
        return false
    }
    
    // A textual representation of the AWSToken
    public var description: String {
        if let tokenString = tokenString, let expiry = expiry {
            return "AWSToken: Token :\(tokenString), Expiration Date: \(expiry)"
        }
        return ""
    }
}
