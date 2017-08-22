//
//  Observable+Response.swift
//  BetterNetworking
//
//  Created by Damian Esteban on 5/7/17.
//  Copyright © 2017 Damian Esteban. All rights reserved.
//

import Foundation
import RxSwift
import Moya

// MARK: - Convenience extensions for ObservableType and Moya Response
public extension ObservableType where E == Response {
    
    /// Maps a moya response to a json dictionary
    ///
    /// - Returns: An observable sequence of the json dictionary
    public func mapDictionary() -> Observable<JSONDictionary> {
        return flatMap { response -> Observable<JSONDictionary> in
            return Observable.just(try response.mapDictionary())
        }
    }
}

public extension Response {
    
    /// Maps a moya response to a json dictionary
    ///
    /// - Returns: An observable sequence of the json dictionary
    /// - Throws: `MoyaError`
    public func mapDictionary() throws -> JSONDictionary {
        let any = try self.mapJSON()
        guard let dictionary = any as? JSONDictionary else {
            throw MoyaError.jsonMapping(self)
        }
        return dictionary
    }
}

public extension Response {
    
    /// Extracts the "top level" json dictionary and returns it as a response
    ///
    /// - Parameter path: The path
    /// - Note: the path should always be "result", which is why it is set to `nil` by default.
    /// - Returns: The new response
    public func extract(from path: String? = nil) -> Response {
        guard let json = try? self.mapJSON() as? JSONDictionary,
            let result = json?["result"] as? JSONDictionary,
            let resultData = try? JSONSerialization.data(withJSONObject: result, options: .prettyPrinted) else {
                return self
        }
        
        let extractedResponse = Response(statusCode: self.statusCode, data: resultData, request: self.request,
                                         response: self.response)
        return extractedResponse
    }
}
