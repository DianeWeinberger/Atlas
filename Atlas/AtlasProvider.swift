//
//  AtlasProvider.swift
//  Atlas
//
//  Created by Damian Esteban on 5/8/17.
//  Repurposed by Magfurul Abeer on 8/17/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import Foundation
import Moya
import RxSwift
import AWSCore
import AWSCognitoIdentityProvider
import Alamofire
import JWTDecode
import ObjectMapper
import RxSwiftExt
import Dotzu

// This subclass is required to override the request method (and automatically refresh the token)
public final class AtlasProvider: RxMoyaProvider<AtlasAPI> {
  
  // MARK: - Initializer
  public init(endpointClosure: @escaping MoyaProvider<AtlasAPI>.EndpointClosure = MoyaProvider.defaultEndpointMapping,
              requestClosure: @escaping MoyaProvider<AtlasAPI>.RequestClosure = MoyaProvider.defaultRequestMapping,
              stubClosure: @escaping MoyaProvider<AtlasAPI>.StubClosure = MoyaProvider.neverStub,
              manager: Manager = Alamofire.SessionManager.default,
              plugins: [PluginType] = []) {
    
    super.init(endpointClosure: endpointClosure, requestClosure: requestClosure, stubClosure: stubClosure, manager: manager, plugins: plugins)
  }
  
  /// Decodes a json web token
  ///
  /// - Parameter token: The token.
  /// - Returns: A decoded jwt.
  /// - Throws: error
  public func decodeToken(_ token: String) throws -> JWT {
    do {
      let decodedToken = try decode(jwt: token)
      return decodedToken
    } catch let error {
      throw error
    }
  }
  
  /// Requests a new identity token from AWS Cognito
  ///
  /// - Returns: An observable sequence that contains the token
  public func awsTokenRequest() -> Observable<String?> {
    
    print("AWS TOKEN REQUEST")
    
    // Is the token valid?
    if Storage.token.isValid {
      return Observable.just(Storage.token.tokenString)
    }
    
    print("TOKEN IS VALID")
    
    // Has the user completed the signup process?
    if UserDefaults.standard.bool(forKey: "didCompleteCognitoSignup") == false {
      return Observable.just(" ")
    }
    
    print("DID COMPLETE SIGNUP")
    
    // Otherwise, use cognito to fetch a new token
    let currentUser = CognitoStore.sharedInstance.currentUser
    
    
    // TODO: - Refactor out to separate method, remove side effects. This method is doing too much.
    return Observable.create { observer in
      currentUser?.getSession().continueWith(block: { (task) -> Any? in
         print("IN OBSERVABLE BLOCK")
        if let result = task.result {
          guard let token = result.idToken?.tokenString else { return nil }
          
           print("TOKEN EXISTS")
          do {
            let decodedToken = try self.decodeToken(token)
            Storage.token.tokenString = decodedToken.string
            Storage.token.expiry = decodedToken.expiresAt
            observer.onNext(token)
             print("ON NEXT TOKEN")
            observer.onCompleted()
          } catch let error {
            observer.onError(error)
          }
          
        } else if let error = task.error {
          observer.onError(error)
        }
        return nil
      })
      return Disposables.create { }
    }
  }
  
  /// Performs a network request
  ///
  /// - Parameter token: The target.
  /// - Returns: An observable sequence that contains the response.
  override public func request(_ token: AtlasAPI) -> Observable<Moya.Response> {
    print("REQUEST")
    let actualRequest = super.request(token)
    
    
    return self.awsTokenRequest().flatMap { _ in
      actualRequest
    }
  }
  
  /// Makes an HTTP request and returns nothing...kind of.
  /// This is for status code 204, when there is no data returned.
  ///
  /// - Parameter target: the target.
  /// - Returns: An observable sequence of  - void -
  public func requestVoid(_ target: AtlasAPI) -> Observable<Void> {
    return request(target)
      .debug("requestVoid")
      // .filter(statusCode: 204) - Enable this when there are real status codes
      .map { response -> Void in
        return void(response)
      }
      .catchError { error in
        throw error
    }
  }
  
  /// Makes an HTTP request and returns a string
  ///
  /// - Parameter target: the target.
  /// - Returns: An observable sequence that contains the response string.
  public func requestString(_ target: AtlasAPI) -> Observable<String> {
    return request(target)
      .debug("requestString")
      .mapString()
      .catchError { error in
        throw error
    }
  }
  
  
  /// Makes an HTTP request and returns an image
  ///
  /// - Parameter target: the target
  /// - Returns: An observable sequence that contains the response as a `UIImage`
  public func requestImage(_ target: AtlasAPI) -> Observable<UIImage> {
    return request(target)
      .debug("requestImage")
      .mapImage()
      .unwrap()
      .catchError { error in
        throw error
    }
  }
  
  /// Makes an HTTP request and return data
  ///
  /// - Parameter target: the target.
  /// - Returns: An observable sequence that contains the response as data.
  public func requestData(_ target: AtlasAPI) -> Observable<Data> {
    return request(target)
      .debug("requestData")
      // .filterSuccessfulStatusCodes() - Enable this when there are real status codes
      .map { response -> Data in
        return response.data
      }
      .catchError { error in
        throw error
    }
  }
  
  /// Makes an HTTP request and returns a json dictionary
  ///
  /// - Parameter target: the target.
  /// - Returns: An observable sequence that contains the response as a json dictionary.
  public func requestJSON(_ target: AtlasAPI) -> Observable<JSONDictionary> {
    return request(target)
      .debug("requestJSON")
      // .filterSuccessfulStatusCodes() - Enable this when there are real status codes
      .map { response -> Response in
        return response.extract()
      }
      .mapDictionary()
      .catchError { error in
        print(error)
        throw error
    }
  }
  
  /// Makes an HTTP request and returns an object that conforms to `BaseMappable`.
  ///
  /// - Parameters:
  ///   - target: the target.
  ///   - type: the type of the object.
  /// - Returns: An observable sequence that contains the response as an object.
  public func requestObject<T: ImmutableMappable>(_ target: AtlasAPI, type: T.Type) -> Observable<T> {
    return request(target)
      .debug("requestObject")
      // .filterSuccessfulStatusCodes() - Enable this when there are real status codes
      .map { response -> Response in
        return response.extract()
      }
      .mapImmutableObject(T.self)
      .catchError { error in
        throw error
    }
  }
  
  /// Makes an HTTP request and returns an array of objects that conform to `BaseMappable`
  ///
  /// - Parameters:
  ///   - target: the target.
  ///   - type: the type of object.
  /// - Returns: An observable sequence that contains the response as an array of objects.
  public func requestObjects<T: ImmutableMappable>(_ target: AtlasAPI, type: T.Type) -> Observable<[T]> {
    return request(target)
      .debug("requestObjects")
      .map { response -> Response in
        response.extract()
      }
      .mapImmutableObjects([T].self)
      .catchError { error in
        throw error
    }
  }
  
  /// Makes an HTTP request and returns an array of nested objects that conform to `ImmutableMappable`
  ///
  /// - Parameters:
  ///   - target: the target
  ///   - type: the type of object
  ///   - nestedLabel: the "nested label"
  /// - Remark: see `mapNestedImmutableObjects` documentation
  /// - Returns: An observable sequence that contains the response as an array of nested objects.
  public func requestNestedObjects<T: ImmutableMappable>(_ target: AtlasAPI, type: T.Type, nestedLabel: String) -> Observable<[T]> {
    return request(target)
      .debug("requestNestedObjects")
      .map { response -> Response in
        response.extract()
      }
      .mapNestedImmutableObjects([T].self, nestedLabel: nestedLabel)
      .catchError { error in
        throw error
    }
  }
  
  public func requestTopLevelObjects<T: ImmutableMappable>(_ target: AtlasAPI, type: T.Type) -> Observable<[T]> {
    return request(target)
      .debug("requestTopLevelObjects")
      .mapNestedImmutableObjects([T].self, nestedLabel: "result")
      .catchError { error in
        throw error
    }
  }
}
