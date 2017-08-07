//
//  ConnectViewController.swift
//  Atlas
//
//  Created by Magfurul Abeer on 7/27/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SDWebImage
import DeckTransition
import RxKeyboard

class ConnectViewController: UIViewController, BindableType {

  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var segmentedControl: TwicketSegmentedControl!
  @IBOutlet weak var searchBarHeightConstraint: NSLayoutConstraint!
  @IBOutlet weak var searchBarTopConstraint: NSLayoutConstraint!
  
  var viewModel: ConnectViewModel!
  var halfwayMark: CGFloat = 0
  
  var segmentedControlOnTop: Bool {
    self.view.layoutIfNeeded()
    return segmentedControl.frame.origin.y == 25
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let displacement = self.segmentedControl.frame.origin.y - 25
    halfwayMark = displacement / 3 * 2
    
    self.navigationController?.hidesBarsOnSwipe = true

    bindViewModel()
    configureNavigation()
    configureSearchBar()
    configureSegmentedControl()
    configureTableView() // Configure last. Requires observables to be set up.
    setUpCollapsibleHeader()
  }
  
  func bindViewModel() {
    viewModel.filterText = searchBar.rx.text.asObservable().throttle(0.5, scheduler: MainScheduler.instance)
    viewModel.selectedIndex = segmentedControl.didSelect.asObservable()
  }
}


extension ConnectViewController {
  func configureTableView() {
    viewModel.displayedUsers
      .bind(to: tableView.rx.items(cellIdentifier: ConnectTableViewCell.reuseIdentifier, cellType: ConnectTableViewCell.self)) {
        row, user, cell in
        cell.configure(from: user)
      }
      .addDisposableTo(rx_disposeBag)
    
    
    tableView.rx.modelSelected(User.self)
      .subscribe(onNext: { [weak self] user in
        OperationQueue.main.addOperation {
          self?.searchBar.resignFirstResponder()
          let modal = UIStoryboard(name: "Connect", bundle: nil).instantiateViewController(withIdentifier: "userDetail") as! UserDetailViewController
          modal.user.value = user
          let transitionDelegate = DeckTransitioningDelegate()
          modal.transitioningDelegate = transitionDelegate
          modal.modalPresentationStyle = .custom
          self?.navigationController?.present(modal, animated: true, completion: nil)
        }
      })
      .addDisposableTo(rx_disposeBag)
  }
  
  func configureSearchBar() {
    searchBar.backgroundColor = UIColor(255, 160, 124)
    if let searchTextField = self.searchBar.value(forKey: "searchField") as? UITextField {
      searchTextField.textColor = UIColor.white
    }
  }
  
  func configureSegmentedControl() {
    segmentedControl.defaultTextColor = Colors.darkGray
    segmentedControl.sliderBackgroundColor = Colors.orange.orangeRed
    segmentedControl.setSegmentItems(["Find", "Friends", "Requests"])
  }
  
  func configureNavigation() {
    navigationController?.navigationBar.barTintColor = Colors.orange.orangeRed
    navigationController?.navigationBar.titleTextAttributes = [
      NSForegroundColorAttributeName: UIColor.white,
      NSFontAttributeName: UIFont(name: "Open Sans", size: 14)!
    ]
  }
}

extension ConnectViewController: HeaderCollapsible {
  
  var defaultTable: UITableView {
    return tableView
  }
  
  func onRelease() {
    if !self.segmentedControlOnTop {
      
      UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
        self.navigationController?.navigationBar.center.y = 45
        self.searchBarHeightConstraint.constant = 44
        self.searchBarTopConstraint.constant = 0
        self.searchBar.alpha = 1
        self.navigationController?.navigationBar.alpha = 1
        
        self.view.layoutIfNeeded()
      }) { (complete) in
        self.searchBar.tag = 0
      }

    }
  }
  
  func onScrollDown(displacement: CGFloat) {
    
    if self.segmentedControlOnTop  {
      self.searchBar.tag = 1
    }
    
    if self.searchBar.tag == 1 {
      self.searchBarTopConstraint.constant -= displacement / 5
    } else {
      self.searchBarHeightConstraint.constant += abs(self.tableView.contentOffset.y) / (667/153)
    }
    
  }
 
  func onScrollUp(displacement: CGFloat) {
    guard self.segmentedControl.tag == 0,       // Prevent running code during animation
      !self.segmentedControlOnTop else { return } // No need to run code when segmented control is at top
    
    if self.searchBar.center.y <= self.halfwayMark {
      self.segmentedControl.tag = 1
      let displacement = self.segmentedControl.frame.origin.y - 25
      
      OperationQueue.main.addOperation {
        self.searchBarTopConstraint.constant -= displacement
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
          self.view.layoutIfNeeded()
          self.searchBar.alpha = 0
          self.navigationController?.navigationBar.alpha = 0
        }) { (complete) in
          self.segmentedControl.tag = 0
          self.searchBar.alpha = 1
        }
      }
    } else {
      self.navigationController?.navigationBar.center.y  -= displacement / 500
      self.searchBarTopConstraint.constant  -= displacement / 500
      self.view.layoutIfNeeded()
    }

  }
}
