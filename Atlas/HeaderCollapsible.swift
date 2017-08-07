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

protocol HeaderCollapsible {
  var defaultTable: UITableView { get }
  func onScrollUp(displacement: CGFloat)
  func onScrollDown(displacement: CGFloat)
  func onRelease()
}

// Use sourcery to set defaultTable and to call setUpCollapsibleHeader at end of viewdidload
extension HeaderCollapsible where Self: UIViewController {
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
