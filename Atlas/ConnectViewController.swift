//
//  ConnectViewController.swift
//  Atlas
//
//  Created by Magfurul Abeer on 7/27/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import UIKit
import TwicketSegmentedControl
import RxSwift
import RxCocoa
import SDWebImage

class ConnectViewController: UIViewController {

  @IBOutlet weak var searchBar: UISearchBar!
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var segmentedControl: TwicketSegmentedControl!
  
  let user = Variable<User>(MockUser.ironMan())
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    print(user.value.friends)
    user.asObservable()
      .map { $0.friends.toArray() }
      .bind(to: tableView.rx.items(cellIdentifier: "CONNECT_TABLEVIEW_CELL", cellType: ConnectTableViewCell.self)) {
        row, user, cell in
        if let url = user.url {
          cell.avatarImageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "deadpool"))
          cell.avatarImageView.layer.cornerRadius = cell.avatarImageView.frame.width / 2
          cell.avatarImageView.layer.masksToBounds = true
        }
        cell.nameTextLabel.text = "\(user.firstName) \(user.lastName)"
//        cell.locationTextLabel.text = 
      }
      .addDisposableTo(rx_disposeBag)
    // Do any additional setup after loading the view.
  }
  
}
