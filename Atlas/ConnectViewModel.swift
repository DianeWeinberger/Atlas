//
//  ConnectViewModel.swift
//  Atlas
//
//  Created by Magfurul Abeer on 7/28/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import Foundation
import RxSwift
import Action

class ConnectViewModel  {
  var coordinator: CoordinatorType
  
  // MARK: Input
  var selectedIndex: Observable<Int>!
  var filterText: Observable<String?>!
  
  // MARK: Output
  lazy var displayedUsers: Observable<[User]> = {
    return self.selectedIndex
      .flatMapLatest { index -> Observable<[User]> in          
        print(index)
        switch index {
        case 0:
          return self.allUsers.asObservable()
        case 1:
          return self.friends
        case 2:
          return Observable.of([])
        default:
          return Observable.empty()
        }
      }
      .withLatestFrom(self.filterText, resultSelector: {users, query -> ([User], String) in
        return (users, query ?? "")
      })
      .map { users, query -> [User] in
        print("before")
        print(users.map({ $0.firstName }))
        return users.filter { user -> Bool in
         return user.fullName.contains(query)
        }
      }
  }()
  
  fileprivate let allUsers = Variable<[User]>([MockUser.ironMan(), MockUser.hulk(), MockUser.captainAmerica()])
  
  fileprivate let user = Variable<User>(MockUser.ironMan())

  fileprivate lazy var friends: Observable<[User]> = {
    return self.user.asObservable()
      .map { $0.friends.toArray() }
  }()
  
  
  init(coordinator: CoordinatorType) {
    self.coordinator = coordinator
  }
}
