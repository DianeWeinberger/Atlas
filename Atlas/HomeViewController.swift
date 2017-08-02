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
  @IBOutlet weak var logoView: UIView!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var segmentedControl: TwicketSegmentedControl!
  
  var viewModel: HomeViewModel!
  
  var pastelView: PastelView?
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }

//  let user = Variable<User>(MockUser.ironMan())
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
//    logoView.layer.cornerRadius = logoView.bounds.height / 2
//    
    bindViewModel()
//    configureSegmentedControl()
//    configureTableView()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
//    configureGradient()

  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
//    guard let pastelView = self.pastelView else { return }
//    
//    pastelView.startAnimation()
  }
  
  
  func bindViewModel() {
    viewModel.selectedIndex = segmentedControl.didSelect.asObservable()
  }
}

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
        //        cell.locationTextLabel.text =
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
    
    pastelView.alpha = 0.15
    
    bannerView.insertSubview(pastelView, at: 0)
  }
}
