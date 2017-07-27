//
//  Coordinator.swift
//  Atlas
//
//  Created by Magfurul Abeer on 7/19/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class Coordinator: CoordinatorType {
  fileprivate var window: UIWindow
  var currentViewController: UIViewController
  
  required init(window: UIWindow) {
    self.window = window
    currentViewController = window.rootViewController!
  }
  
  static func actualViewController(for viewController: UIViewController) -> UIViewController {
    if let navigationController = viewController as? UINavigationController {
      return navigationController.viewControllers.first!
    } else {
      return viewController
    }
  }
  
  @discardableResult
  func transition(to scene: SceneType, type: TransitionType) -> Observable<Void> {
    let subject = PublishSubject<Void>()
    let viewController = scene.viewController
    switch type {
    case .root:
      currentViewController = Coordinator.actualViewController(for: viewController)
      window.rootViewController = viewController
      subject.onCompleted()
      
    case .push:
      guard let navigationController = currentViewController.navigationController else {
        fatalError("Can't push a view controller without a current navigation controller")
      }
      // one-off subscription to be notified when push complete
      _ = navigationController.rx.delegate
        .sentMessage(#selector(UINavigationControllerDelegate.navigationController(_:didShow:animated:)))
        .map { _ in }
        .bind(to: subject)
      navigationController.pushViewController(viewController, animated: true)
      currentViewController = Coordinator.actualViewController(for: viewController)
      
    case .modal:
      currentViewController.present(viewController, animated: true) {
        subject.onCompleted()
      }
      currentViewController = Coordinator.actualViewController(for: viewController)
    }
    return subject.asObservable()
      .take(1)
      .ignoreElements()
  }
  
  @discardableResult
  func pop(animated: Bool) -> Observable<Void> {
    let subject = PublishSubject<Void>()
    if let presenter = currentViewController.presentingViewController {
      // dismiss a modal controller
      currentViewController.dismiss(animated: animated) {
        self.currentViewController = Coordinator.actualViewController(for: presenter)
        subject.onCompleted()
      }
    } else if currentViewController is UITabBarController {
      guard let modal = currentViewController.presentedViewController else {
        fatalError("\(currentViewController) is not presenting a view controller")
      }
      
      modal.dismiss(animated: animated) {
        subject.onCompleted()
      }
    } else if let navigationController = currentViewController.navigationController {
      // navigate up the stack
      // one-off subscription to be notified when pop complete
      _ = navigationController.rx.delegate
        .sentMessage(#selector(UINavigationControllerDelegate.navigationController(_:didShow:animated:)))
        .map { _ in }
        .bind(to: subject)
      guard navigationController.popViewController(animated: animated) != nil else {
        fatalError("can't navigate back from \(currentViewController)")
      }
      currentViewController = Coordinator.actualViewController(for: navigationController.viewControllers.last!)
    } else {
      fatalError("Not a modal, no navigation controller: can't navigate back from \(currentViewController)")
    }
    return subject.asObservable().take(1).ignoreElements()
  }
}
