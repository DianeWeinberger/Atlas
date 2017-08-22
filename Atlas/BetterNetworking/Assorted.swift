//
//  UIImage+base64.swift
//  BetterNetworking
//
//  Created by Damian Esteban on 5/12/17.
//  Copyright © 2017 Damian Esteban. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import AWSCore
import ObjectMapper

/// 🌇 📐 ImageSize - see `BetterAPI` `fetchAvatar` route
public enum ImageSize: String {
    case small
    case original
    case large
}

// MARK: - Fun pipe operator
precedencegroup LeftFunctionalApply {
    associativity: left
    higherThan: AssignmentPrecedence
    lowerThan: TernaryPrecedence
}

infix operator |>: LeftFunctionalApply

// MARK: - Compose operator
public func |><In, Out>(lhs: In, rhs: (In) throws -> Out) rethrows -> Out {
    return try rhs(lhs)
}

// MARK:  Base64String type
public typealias Base64String = String

// MARK: - Assorted functions

/// Returns an observable sequence from an AWSTask
///
/// - Parameter task: The task
/// - Returns: An observable sequence of the task
public func awsTaskToObservable<T>(_ task: AWSTask<T>) -> Observable<T> {
    return Observable.create { observer in
        task.continueWith { result in
            if let result = task.result {
                observer.onNext(result)
                observer.onCompleted()
            }
            if let error = task.error {
                observer.onError(error)
            }
            return nil
        }
        return Disposables.create()
    }
}

// NOTE: - I'm aware I could have just kept the extensions, or even have just written a single function.
// But this is more fun.

/// Returns the data representation of an image
///
/// - Parameter image: The image
/// - Returns: The data representation
public func data(from image: UIImage) -> Data {
    return UIImagePNGRepresentation(image)!
}

/// Returns the Base64String representation of data
///
/// - Parameter data: The data
/// - Returns: The Base64String representation
public func base64String(from data: Data) -> Base64String {
   return data.base64EncodedString(options: .lineLength64Characters)
}

/// Returns Void
///
/// - Parameter _: The type
public func void<T>(_: T) -> Void {
    return Void()
}


