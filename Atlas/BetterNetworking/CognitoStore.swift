//
//  CognitoStore.swift
//  Pods
//
//  Created by Damian Esteban on 6/6/17.
//
//

import Foundation
import AWSCore
import AWSCognitoIdentityProvider

/// 🕵️ CognitoStore
public final class CognitoStore: NSObject {
    
    // MARK: - Singleton
    
    public static let sharedInstance = CognitoStore()
    
    // MARK: - Properties
    
    public var credentialsProvider: AWSCognitoCredentialsProvider
    public var userPool: AWSCognitoIdentityUserPool
    
    public var currentUser: AWSCognitoIdentityUser? {
        return self.userPool.currentUser()
    }
  
    // The VC that starts the login/signup process should be set as the delegate.
    public var delegate: AWSCognitoIdentityInteractiveAuthenticationDelegate {
        get {
            return userPool.delegate
        }
        set {
            userPool.delegate = newValue
        }
    }
    
    // MARK: - Initializer(s)
    
    private override init() {
        // Placed this in a private init to make the CognitoStore a true singleton. Several of these calls
        // can only be made once, as they configure settings for the entire AWS Cognito sdk, e.g.
        // http://amzn.to/2riUP44.
        var configuration = AWSServiceConfiguration(region: Constants.AWS.region, credentialsProvider: nil)
        
        let userPoolConfiguration = AWSCognitoIdentityUserPoolConfiguration(
            clientId: Constants.AWS.clientId,
            clientSecret: Constants.AWS.clientSecret,
            poolId: Constants.AWS.poolId)
        
        AWSCognitoIdentityUserPool.register(with: configuration,
                                            userPoolConfiguration: userPoolConfiguration,
                                            forKey: Constants.AWS.userPoolKey)
        
        self.userPool = AWSCognitoIdentityUserPool(forKey: Constants.AWS.userPoolKey)
        
        self.credentialsProvider = AWSCognitoCredentialsProvider(
            regionType: Constants.AWS.region,
            identityPoolId: Constants.AWS.identityPoolId,
            identityProviderManager: self.userPool)
        
        configuration = AWSServiceConfiguration(region: Constants.AWS.region,
                                                credentialsProvider: self.credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        super.init()
    }
}
