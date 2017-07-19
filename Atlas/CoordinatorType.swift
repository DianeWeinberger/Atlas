//
//  CoordinatorType.swift
//  Atlas
//
//  Created by Magfurul Abeer on 7/19/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import UIKit
import RxSwift

protocol CoordinatorType {
  init(window: UIWindow)
  
  /// transition to another scene
  @discardableResult
  func transition(to scene: Scene, type: TransitionType) -> Observable<Void>
  
  /// pop scene from navigation stack or dismiss current modal
  @discardableResult
  func pop(animated: Bool) -> Observable<Void>
}

extension CoordinatorType {
  @discardableResult
  func pop() -> Observable<Void> {
    return pop(animated: true)
  }
}
