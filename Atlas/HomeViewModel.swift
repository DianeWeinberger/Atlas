//
//  HomeViewModel.swift
//  Atlas
//
//  Created by Magfurul Abeer on 8/1/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import Foundation
import RxSwift
import Action

class HomeViewModel  {
  var coordinator: CoordinatorType
  
  // MARK: Input
  var selectedIndex: Observable<Int>!
//  var filterText: Observable<String?>!
  
  // MARK: Output
  lazy var myActivity: Observable<[Event]> = {
    return self.user.asObservable()
      .map { user -> [Event] in
        return user.history.toArray()
      }
  }()
  
  lazy var friendsActivity: Observable<[Event]> = {
    return self.user.asObservable()
      .map { user -> [User] in
        return user.friends.toArray()
      }
      .map { friends -> [Event] in
        return friends
          .flatMap { $0.history }
          .sorted(by: Event.sortLatest)
      }
  }()
  
  
  // MARK: Observables
  lazy var selectedActivity: Observable<[Event]> = {
    return self.selectedIndex
      .startWith(0)
      .flatMapLatest { index -> Observable<[Event]> in
        switch index {
        case 0: // My Activity
          return self.myActivity
        case 1: // ALL
          return self.friendsActivity
        default:
          // TODO: Throw Observable.error instead
          return Observable.empty()
        }
    }
  }()
  
  // MARK: Actions
  func didSelectModel(user: User) {
    coordinator.transition(to: ConnectScene.details(user), type: .modal)
  }
  
  fileprivate let allUsers = Variable<[User]>([MockUser.dareDevil()])
  
  fileprivate let user = Variable<User>(MockUser.ironMan())
  
  fileprivate lazy var friends: Observable<[User]> = {
    return self.user.asObservable()
      .map { $0.friends.toArray() }
  }()
  
  
  init(coordinator: CoordinatorType) {
    self.coordinator = coordinator
  }
}
