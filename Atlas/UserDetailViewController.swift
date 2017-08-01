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
    nameLabel.text = "\(user.value.firstName) \(user.value.lastName.characters.first!)."
    history
      .bind(to: activityTableView.rx.items(cellIdentifier: "Subtitle")) {
        [weak self] row, event, cell in
        cell.textLabel?.text = "\(self!.user.value.firstName) \(event.title)"
        cell.detailTextLabel?.text = event.timestamp.shortDate
      }
      .addDisposableTo(rx_disposeBag)
  }

}
