//
//  Provider.swift
//  BetterNetworking
//
//  Created by Damian Esteban on 3/8/17.
//  Copyright © 2017 Damian Esteban. All rights reserved.
//

import Foundation
import RxSwift
import Moya
import Result

public typealias JSONDictionary = [String: Any]

let stubsPath = Bundle.main.resourceURL!.appendingPathComponent("Stubs").path

// Protocol for authentication
protocol TokenAuthAPIType {
  var needsXAuth: Bool { get }
}

// Moya Plugin for JSON formatting
public func JSONResponseDataFormatter(_ data: Data) -> Data {
  do {
    let dataAsJSON = try JSONSerialization.jsonObject(with: data)
    let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
    return prettyData
  } catch {
    return data // fallback to original data if it can't be serialized.
  }
}

// FIXME: - (note) Add permalink to Moya Docs and short overview. For now,
// please see Moya documentation and examples for more general information about `TargetType`,
// `RxMoyaProvider`, `Endpoint` and all of this other fun stuff - https://github.com/Moya/Moya

// MARK: - Endpoint closure.  Adds the JWT to the header for the necessary targets.
public let endpointClosure = { (target: AtlasAPI) -> Endpoint<AtlasAPI> in
  let defaultEndpoint = AtlasProvider.defaultEndpointMapping(for: target)
  
  if target.needsXAuth {
    return defaultEndpoint.adding(httpHeaderFields: ["Authorization": AWSToken().tokenString ?? ""])
  }
  return defaultEndpoint
}

// MARK: - The Atlas api represented as an enum.
public enum AtlasAPI: TargetType {
    // User
    case user(dictionary: JSONDictionary)
    case fetchUserById(id: String)
    case updateUser(dictionary: JSONDictionary)
    case addUserLocation(dictionary: JSONDictionary)
    case removeUserLocation(locationId: Int)
    case uploadAvatar(base64String: Base64String)
    case fetchAvatar(id: Int, imageSize: ImageSize, filename: String)
}

extension AtlasAPI: TokenAuthAPIType {
    
    // MARK: - All endpoints that need a token in the header
    public var needsXAuth: Bool {
        switch self {
        case  .fetchUserById, .updateUser, .addUserLocation,
              .removeUserLocation, .uploadAvatar, .fetchAvatar:
            return true
        case .user:
          return false
        }
      
    }
    
    // The base url
    public var baseURL: URL {
        switch self {
        default:
            return URL(string: Constants.API.baseURL)!
        }
    }
    
    public var parameterEncoding: ParameterEncoding {
        switch self {
        case .fetchAvatar, .fetchUserById:
            return URLEncoding.default
        default:
            return JSONEncoding.default
        }
    }
    
    public var task: Task {
        return .request
    }
    
    public var path: String {
        switch self {
        case .user(dictionary: _):
          return "/users"
        case .fetchUserById(let id):
          return "/users/\(id)"
        default:
          return ""
        }
    }

    public var parameters: [String : Any]? {
        switch self {
        case .user(let dictionary):
            return dictionary
        case .fetchUserById, .removeUserLocation:
            return nil
        case .fetchAvatar(_, let size, let filename):
            return ["size": size, "fn": "\(size)-\(filename)"]
        case .updateUser(let dictionary):
            return dictionary
        case .addUserLocation(let dictionary):
            return dictionary
        case .uploadAvatar(let base64String):
            return ["file": base64String]
        }
    }
  
    // TODO: Should .uploadAvatar be a POST?
    public var method: Moya.Method {
        switch self {
        case .user, .addUserLocation, .uploadAvatar:
            return .post
        case .fetchUserById, .fetchAvatar:
            return .get
        case .updateUser:
            return .put
        case .removeUserLocation:
            return .delete
        }
    }
    
    public var stubStatusCode: Int {
        return 200
    }
    
    // TODO: - Start adding stubs once the backend is a bit more stable.
    public var sampleData: Data {
        return "".data(using: .utf8)!
    }
}

extension AtlasAPI {
    
    /// Filters out optional parameters in a dictionary
    ///
    /// - Parameter optionalParameters: the parameters (dictionary)
    /// - Returns: the filtered parameters (dictionary)
    public func filterOptionalParameters(_ optionalParameters:[String: Any?]) -> [String: Any]? {
        var nonOptionalParams: [String: Any] = [:]
        
        for (key, value) in optionalParameters {
            if let value = value {
                nonOptionalParams[key] = value
            }
        }
        if nonOptionalParams.isEmpty {
            return nil
        }
        return nonOptionalParams
    }
}
