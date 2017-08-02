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
  var header = HomeHeaderView()
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }

//  let user = Variable<User>(MockUser.ironMan())
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
//    logoView.layer.cornerRadius = logoView.bounds.height / 2
    
    
    
//    configureSegmentedControl()
//    configureTableView()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
//    configureGradient()
    
    let headerSize = CGSize(width: self.tableView.frame.width,
                            height: self.tableView.frame.height * 0.6)
    self.header = HomeHeaderView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    
    self.tableView.addSubview(self.header)
    self.header.translatesAutoresizingMaskIntoConstraints = false
    self.header.topAnchor.constraint(equalTo: self.tableView.topAnchor).isActive = true
    self.header.widthAnchor.constraint(equalTo: self.tableView.widthAnchor).isActive = true
    self.header.centerXAnchor.constraint(equalTo: self.tableView.centerXAnchor).isActive = true
    self.header.heightAnchor.constraint(equalTo: self.tableView.heightAnchor, multiplier: 0.6).isActive = true
    bindViewModel()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
//    guard let pastelView = self.pastelView else { return }
//    
//    pastelView.startAnimation()
  }
  
  
  func bindViewModel() {
    viewModel.selectedIndex = header.segmentedControl.didSelect.asObservable()
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
