//
//  HeaderCollapsible.swift
//  Atlas
//
//  Created by Magfurul Abeer on 8/4/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

/**
 UIViewControllers that conform to this protocol have a UITableView 
 that implements Collapsible and/or Sticky Headers.
 
 Sourcery is being used to generate code to set the defaultTable (assuming there is only one UITableView)
 
 NOTE: Remember to call setUpCollapsibleHeader at end of viewDidLoad
 
 :see: HomeViewController
       ConnectViewController
       UserDetailViewController
 */
public protocol HeaderCollapsible {
  
  /**
   The UITableView that implements the Header
   */
  var defaultTable: UITableView { get }
  
  /**
   Runs whenever the user scrolls the UITableView up
   
   - Parameter displacement: The amount scrolled
   */
  func onScrollUp(displacement: CGFloat)
  
  /**
   Runs whenever the user scrolls the UITableView down
   
   - Parameter displacement: The amount scrolled
   */
  func onScrollDown(displacement: CGFloat)
  
  /**
   Runs whenever the user stops scrolling the UITableView
   */
  func onRelease()
}

//
/**
 Runs whenever the user scrolls the UITableView up
 
 - Parameter displacement: The amount scrolled
 */
public extension HeaderCollapsible where Self: UIViewController {
  
  /**
   Subscribes to the UITableView's ControlEvents and runs the
   given code in the respective subscription
   */
  func setUpCollapsibleHeader() {
    
    let tableView = self.defaultTable
    let didEndDragging = tableView.rx.didEndDragging.map { _ in () }
    
    Observable.merge([didEndDragging, tableView.rx.didEndDecelerating.asObservable()])
      .subscribe(onNext: { _ in
        
        self.onRelease()
        
      })
      .addDisposableTo(rx_disposeBag)
    
    let scrollDisplacement = tableView.rx.didScroll
      .withLatestFrom(tableView.rx.contentOffset)
      .map { $0.y }
    
    scrollDisplacement
      .filter { $0 < 0 }
      .subscribe(onNext: { movement in
        
        self.onScrollDown(displacement: movement)
        
      })
      .addDisposableTo(rx_disposeBag)
    
    scrollDisplacement
      .filter { $0 > 0 }
      .subscribe(onNext: { movement in
        self.onScrollUp(displacement: movement)
      })
      .addDisposableTo(rx_disposeBag)
    
  }
}
