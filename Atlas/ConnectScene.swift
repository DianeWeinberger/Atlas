//
//  ConnectScene.swift
//  Atlas
//
//  Created by Magfurul Abeer on 8/1/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import UIKit
import DeckTransition

enum ConnectScene: SceneType {
  case details(User)
}

extension ConnectScene {
  var viewController: UIViewController {
    let storyboard = UIStoryboard(name: "Connect", bundle: nil)
    
    switch self {
    case .details(let user):
      let modal = storyboard.instantiateViewController(withIdentifier: "userDetail") as! UserDetailViewController
      modal.displayedUser.value = user
      let transitionDelegate = DeckTransitioningDelegate()
      modal.transitioningDelegate = transitionDelegate
      modal.modalPresentationStyle = .custom
      return modal
//      self?.navigationController?.present(modal, animated: true, completion: nil)
      
//      var viewController = storyboard.instantiateInitialViewController() as! RunViewController
//      viewController.bindViewModel(to: viewModel)
//      return viewController
    }
  }
}
