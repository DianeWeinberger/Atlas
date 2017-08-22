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

protocol ConnectViewModelInputsType {
  var selectedIndex: Observable<Int>! { get set }
  var filterText: Observable<String?>! { get set }
}

protocol ConnectViewModelOutputsType {
  var displayedUsers: Observable<[User]> { get }
}

protocol ConnectViewModelActionsType {
  func didSelectModel(user: User)
}

protocol ConnectViewModelType {
  var inputs: ConnectViewModelInputsType { get }
  var outputs: ConnectViewModelOutputsType { get }
  var actions: ConnectViewModelActionsType { get }
  var coordinator: CoordinatorType { get set }
}

final class ConnectViewModel: ConnectViewModelType {
  
  var inputs: ConnectViewModelInputsType { return self }
  var outputs: ConnectViewModelOutputsType { return self }
  var actions: ConnectViewModelActionsType { return self }
  var coordinator: CoordinatorType
  
  // MARK: Input
  var selectedIndex: Observable<Int>!
  var filterText: Observable<String?>!
  
  // MARK: Output
  lazy var displayedUsers: Observable<[User]> = {
    return Observable.combineLatest(self.filterText, self.selectedUserGroup) {
        (query, users) -> (String, [User]) in
        return (query ?? "", users)
      }
      .map { query, users in
        return users.filter { user -> Bool in
          guard !query.isEmpty else { return true }
          
          return user.fullName.lowercased()
                  .contains(query.lowercased())
        }
      }
  }()
  
  // MARK: Observables
  fileprivate lazy var selectedUserGroup: Observable<[User]> = {
    return self.selectedIndex
      .startWith(0)
      .flatMapLatest { index -> Observable<[User]> in
        switch index {
        case 0: // Find
          return self.allUsers.asObservable()
        case 1: // Friends
          return self.friends
        case 2: // Requests
          return self.requests
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
  
  fileprivate let allUsers = Variable<[User]>(MockUser.users.toArray())
  
  let user = Variable<User>(MockUser.ironMan)

  fileprivate lazy var friends: Observable<[User]> = {
    return self.user.asObservable()
      .map { $0.friends.toArray() }
  }()
  
  fileprivate lazy var requests: Observable<[User]> = {
    return self.user.asObservable()
      .map { $0.recievedRequests.toArray() }
  }()
  
  init(coordinator: CoordinatorType) {
    self.coordinator = coordinator
  }
}

extension ConnectViewModel: ConnectViewModelInputsType, ConnectViewModelOutputsType, ConnectViewModelActionsType { }
