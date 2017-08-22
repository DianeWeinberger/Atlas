//
//  UserService.swift
//  Atlas
//
//  Created by Magfurul Abeer on 8/22/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import Foundation
import AWSCore
import RxSwift
import RxCocoa

class UserService {
  public static let shared = UserService()

  private let api = AtlasProvider()
  
  func createUser(id: String, credentials: SignUpCredentials) -> Observable<JSONDictionary> {
    print(id)
    print(credentials)
    let (firstName, lastName, email, _) = credentials
    let data = [
      "id": id,
      "firstName": firstName,
      "lastName": lastName,
      "email": email
    ]
    return api.requestJSON(AtlasAPI.user(dictionary: data))
  }
  
  func getUser(id: String) -> Observable<JSONDictionary> {
    return api.requestJSON(AtlasAPI.fetchUserById(id: id))
  }
}
