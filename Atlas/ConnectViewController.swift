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
    
  var viewModel: ConnectViewModel!

  override func viewDidLoad() {
    super.viewDidLoad()
    
    bindViewModel()
    configureNavigation()
    configureSearchBar()
    configureSegmentedControl()
    configureTableView() // Configure last. Requires observables to be set up.
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
      NSFontAttributeName: UIFont(name: "Open Sans", size: 10)!
    ]
  }
}
