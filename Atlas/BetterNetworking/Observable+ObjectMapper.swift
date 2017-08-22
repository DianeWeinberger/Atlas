//
//  Observable+MoyaObjectMapper.swift
//
//  Created by Ivan Bruel on 09/12/15.
//  Copyright © 2015 Ivan Bruel. All rights reserved.
//
import Foundation
import RxSwift
import Moya
import ObjectMapper

// Extensions for Moya+ObjectMapper
extension ObservableType where E == Moya.Response {
   
    /// Maps a single object from json
    ///
    /// - Parameter mappableType: The type of the object
    /// - Returns: An observable sequence of the object
    func mapImmutableObject<T: ImmutableMappable>(_ mappableType: T.Type) -> Observable<T> {
        return self.mapString()
            .map { jsonString -> T in
                return try Mapper<T>().map(JSONString: jsonString)
            }
            .catchError { error in
                throw error
        }
    }
    
    /// Maps an array of objects from json
    ///
    /// - Parameter mappableType: The type of the objects
    /// - Returns: An observable sequence of the objects
    func mapImmutableObjects<T: ImmutableMappable>(_ mappableType: [T].Type) -> Observable<[T]> {
        return self.mapString()
            .map { jsonString -> [T] in
                return try Mapper<T>().mapArray(JSONString: jsonString)
            }
            .catchError { error in
                throw error
        }
    }
    
    /// Maps an array of nested objects from json
    ///
    /// - Parameters:
    ///   - mappableType: The type of objects
    ///   - nestedLabel: The "nested label"
    ///
    /// - Remark:
    /// **Example of a nested array:**
    ///
    ///  ``` {"result":{ "id": 1, "things": [{"name": "Bob", "height": 111}, {"name": "Bill", "height": 113}...]}}```
    /// - Returns: An observable sequence of the nested objects
    func mapNestedImmutableObjects<T: ImmutableMappable>(_ mappableType: [T].Type, nestedLabel: String) -> Observable<[T]> {
        return self.mapDictionary()
            .map { jsonDictionary -> [T] in
                return try Mapper<T>().mapArray(JSONObject: jsonDictionary[nestedLabel] as Any)
            }
            .catchError { error in
                throw error
        }
    }
}
