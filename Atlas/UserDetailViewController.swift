//
//  UserDetailViewController.swift
//  Atlas
//
//  Created by Magfurul Abeer on 7/28/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import UIKit
import DeckTransition
import RxCocoa
import RxSwift

enum UserRelationState {
  case friend
  case requestSent
  case connect
}

// TODO: Make View Model for this
class UserDetailViewController: UIViewController {
  
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var connectButton: UIButton!
  @IBOutlet weak var activityLabel: UILabel!
  @IBOutlet weak var activityTableView: UITableView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var runnerTypeLabel: UILabel!
  @IBOutlet weak var locationLabel: UILabel!
  @IBOutlet weak var expertiseLabel: UILabel!
  @IBOutlet weak var paceLabel: UILabel!
  @IBOutlet weak var totalDistanceLabel: UILabel!
  
  
  var user = Variable<User>(User())
  
  fileprivate lazy var history: Observable<[Event]> = {
    return self.user.asObservable()
      .map { $0.history.toArray() }
  }()
  
  fileprivate lazy var runs: Observable<[Run]> = {
    return self.user.asObservable()
      .map { $0.sortedRuns }
  }()
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    modalPresentationCapturesStatusBarAppearance = true
    
    if let url = user.value.url {
      imageView.sd_setImage(with: url)
    }
    
    activityLabel.text = "\(user.value.firstName)'s Activity"
    nameLabel.text = user.value.displayName
    
    activityTableView.delegate = self
    
    runs
      .bind(to: activityTableView.rx.items(cellIdentifier: RunTableViewCell.reuseIdentifier, cellType: RunTableViewCell.self)) {
        row, run, cell in
        cell.configure(run: run)
      }
      .addDisposableTo(rx_disposeBag)
  }

}

extension UserDetailViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let width = tableView.bounds.width
    return width * 80/375
  }
}
