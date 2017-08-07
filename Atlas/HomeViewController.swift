//
//  HomeViewController.swift
//  Atlas
//
//  Created by Magfurul Abeer on 8/1/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Pastel

class HomeViewController: UIViewController, BindableType {

  @IBOutlet weak var bannerView: UIImageView!
  @IBOutlet weak var logoView: UIImageView!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var segmentedControl: TwicketSegmentedControl!
  @IBOutlet weak var bannerHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var bannerTopConstraint: NSLayoutConstraint!
  @IBOutlet weak var segmentedControlTopConstraint: NSLayoutConstraint!
  
  var viewModel: HomeViewModel!
  
  var pastelView: PastelView?
  var halfwayMark: CGFloat = 0
  
  
  var segmentedControlOnTop: Bool {
    self.view.layoutIfNeeded()
    return segmentedControl.frame.origin.y == 25
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }

//  let user = Variable<User>(MockUser.ironMan())
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let displacement = self.segmentedControl.frame.origin.y - 25
    halfwayMark = displacement / 3 * 2
    
    bindViewModel()
    configureSegmentedControl()
    configureTableView()
    
    setUpCollapsibleHeader()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    if pastelView == nil {
      configureGradient()
    }
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    guard let pastelView = self.pastelView else { return }
    pastelView.startAnimation()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    bannerView.image = BannerImage.random()
  }
  
  func bindViewModel() {
    viewModel.selectedIndex = segmentedControl.didSelect.asObservable()
  }
}





// MARK: Configurations
extension HomeViewController {
  func configureTableView() {
    viewModel.selectedActivity
      .bind(to: tableView.rx.items(cellIdentifier: ActivityTableViewCell.reuseIdentifier, cellType: ActivityTableViewCell.self)) {
        row, event, cell in
        guard let user = event.user else {
          return
        }
        
        cell.avatarImageView.layer.cornerRadius = cell.avatarImageView.frame.width / 2
        cell.avatarImageView.layer.masksToBounds = true
        
        if let url = user.url {
          cell.avatarImageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "deadpool"))
        }
        
        cell.nameLabel.text = "\(user.firstName) \(user.lastName)"
        cell.activityLabel.text = event.title
        cell.nameLabel.text = user.displayName
      }
      .addDisposableTo(rx_disposeBag)
  }
  
  func configureSegmentedControl() {
    segmentedControl.defaultTextColor = Colors.darkGray
    segmentedControl.sliderBackgroundColor = Colors.orange.orangeRed
    segmentedControl.setSegmentItems(["My Activity", "All"])
  }
  
  func configureGradient() {
    let pastelView = PastelView(frame: bannerView.frame)
    self.pastelView = pastelView
    // Custom Direction
    pastelView.startPastelPoint = .bottomLeft
    pastelView.endPastelPoint = .topRight
    
    // Custom Duration
    pastelView.animationDuration = 3
    
    pastelView.startAnimation()
    
    pastelView.setColors([
      Colors.orange.orangeRed,
      Colors.orange.peach,
      Colors.red.carnation,
      Colors.red.pinkishRed,
      Colors.blue.azure,
      Colors.blue.dodger
    ])
    
    pastelView.alpha = 0
    UIView.animate(withDuration: 0.5) { 
      pastelView.alpha = 0.15
    }
    
    bannerView.insertSubview(pastelView, at: 0)
  }
  
  func configureDynamicHeader() {
//    let didEndDragging = tableView.rx.didEndDragging.map { _ in () }
//    
//    Observable.merge([didEndDragging, tableView.rx.didEndDecelerating.asObservable()])
//      .subscribe(onNext: { _ in
//        OperationQueue.main.addOperation {
//          if !self.segmentedControlOnTop {
//            self.animateHeader()
//          }
//        }
//      })
//      .addDisposableTo(rx_disposeBag)
//    
//    let scrollDisplacement = tableView.rx.didScroll
//      .withLatestFrom(tableView.rx.contentOffset)
//      .map { $0.y }
//    
//    scrollDisplacement
//      .filter { $0 < 0 }
//      .subscribe(onNext: { movement in
//        
//        if self.segmentedControlOnTop  {
//          self.bannerView.tag = 1
//        }
//        
//        if self.pastelView?.alpha ?? 0 > 0 {
//          UIView.animate(withDuration: 0.2) {
//            self.pastelView?.alpha = 0
//          }
//        }
//        self.pastelView?.removeFromSuperview()
//        
//        if self.bannerView.tag == 1 {
//          self.bannerTopConstraint.constant -= movement / 5
//        } else {
//          self.pastelView?.alpha = 0
//          self.bannerHeightConstraint.constant += abs(self.tableView.contentOffset.y) / (667/153)
//        }
//
//      })
//      .addDisposableTo(rx_disposeBag)
//    
//    scrollDisplacement
//      .filter { $0 > 0 }
//      .subscribe(onNext: { movement in
//        guard self.segmentedControl.tag == 0,       // Prevent running code during animation
//          !self.segmentedControlOnTop else { return } // No need to run code when segmented control is at top
//        
//        if self.logoView.center.y <= self.halfwayMark {
//          self.segmentedControl.tag = 1
//          let displacement = self.segmentedControl.frame.origin.y - 25
//          
//          OperationQueue.main.addOperation {
//            self.bannerTopConstraint.constant -= displacement
//            
//            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
//              self.view.layoutIfNeeded()
//              self.bannerView.alpha = 0
//              self.logoView.alpha = 0
//            }) { (complete) in
//              self.segmentedControl.tag = 0
//              self.bannerView.alpha = 1
//            }
//          }
//        } else {
//          self.bannerTopConstraint.constant -= movement / 5
//          self.bannerView.alpha -= movement / 500
//          self.logoView.alpha -= movement / 500
//        }
//
//      })
//      .addDisposableTo(rx_disposeBag)

  }
}

extension HomeViewController: HeaderCollapsible {
  
  func onRelease() {
    UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
      self.bannerHeightConstraint.constant = 0
      self.pastelView?.alpha = 0.15
      
      self.bannerTopConstraint.constant = 0
      self.bannerView.alpha = 1
      self.logoView.alpha = 1
      self.pastelView?.alpha = 0.15
      
      self.view.layoutIfNeeded()
    }) { (complete) in
      self.bannerView.tag = 0
    }
  }
  
  func onScrollDown(displacement: CGFloat) {
    
    if self.segmentedControlOnTop  {
      self.bannerView.tag = 1
    }
    
    if self.pastelView?.alpha ?? 0 > 0 {
      UIView.animate(withDuration: 0.2) {
        self.pastelView?.alpha = 0
      }
    }
    self.pastelView?.removeFromSuperview()
    
    if self.bannerView.tag == 1 {
      self.bannerTopConstraint.constant -= displacement / 5
    } else {
      self.pastelView?.alpha = 0
      self.bannerHeightConstraint.constant += abs(self.tableView.contentOffset.y) / (667/153)
    }

  }
  
  func onScrollUp(displacement: CGFloat) {
    guard self.segmentedControl.tag == 0,       // Prevent running code during animation
      !self.segmentedControlOnTop else { return } // No need to run code when segmented control is at top
    
    if self.logoView.center.y <= self.halfwayMark {
      self.segmentedControl.tag = 1
      let displacement = self.segmentedControl.frame.origin.y - 25
      
      OperationQueue.main.addOperation {
        self.bannerTopConstraint.constant -= displacement
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
          self.view.layoutIfNeeded()
          self.bannerView.alpha = 0
          self.logoView.alpha = 0
        }) { (complete) in
          self.segmentedControl.tag = 0
          self.bannerView.alpha = 1
        }
      }
    } else {
      self.bannerTopConstraint.constant -= displacement / 5
      self.bannerView.alpha -= displacement / 500
      self.logoView.alpha -= displacement / 500
    }

  }
}
