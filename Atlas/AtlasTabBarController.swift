//
//  AtlasTabBarController.swift
//  Atlas
//
//  Created by Magfurul Abeer on 7/20/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

typealias TabImage = (normal: UIImage, selected: UIImage)

class AtlasTabBarController: UITabBarController, BindableType {
  
  var viewModel: AtlasTabBarViewModel!
  
  var tabImages: [TabImage] {
    return [
      (#imageLiteral(resourceName: "home"), #imageLiteral(resourceName: "home_active")),
      (#imageLiteral(resourceName: "connect"), #imageLiteral(resourceName: "connect_active")),
      (#imageLiteral(resourceName: "TabBar_RUN_btn"), #imageLiteral(resourceName: "TabBar_RUN_btn")),
      (#imageLiteral(resourceName: "message"), #imageLiteral(resourceName: "message_active")),
      (#imageLiteral(resourceName: "profile"), #imageLiteral(resourceName: "profile_active"))
    ]
  }

  override func viewDidLoad() {
    rx.setDelegate(self).addDisposableTo(rx_disposeBag)
    
    
//    UITabBarItem.appearance().titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -5)
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    tabBar.frame.origin.y += (tabBar.frame.size.height - 45)
    tabBar.frame.size.height = 45
//    tabBar.layer.borderWidth = 0
//    tabBar.layer.borderColor = UIColor.clear.cgColor
//    tabBar.removeShadow()
//    tabBar.shadowImage = UIImage()
//    tabBar.layer.shadowOpacity = 0
    setTabImages()
  }
  
  func setTabImages() {
      guard let items = tabBar.items else { return }
      items.enumerated().forEach { i, tab in
        
        tab.image = tabImages[i].normal
                      .withRenderingMode(.alwaysOriginal)
        
        tab.selectedImage = tabImages[i].selected
                              .withRenderingMode(.alwaysOriginal)
        
        tab.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 11)
        tab.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0)
        
        
        if i == 2 {
          tab.imageInsets = UIEdgeInsetsMake(-10, 0, 10, 0)
        }
      }
  }
 
  
}

extension AtlasTabBarController: UITabBarControllerDelegate {
  func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
    let selectedVC = viewControllers![2]
    
    guard viewController == selectedVC else {
      return true
    }
    
    viewModel.didSelectRunTabBarItem()
    return false
  }
  
//  override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
//    
//    guard let items = tabBar.items else { return }
//    items.enumerated().forEach { i, tab in
//      
//      tab.image = tabImages[i].normal
//        .withRenderingMode(.alwaysOriginal)
//      
//      
//
//    }
//    
//  }
}

