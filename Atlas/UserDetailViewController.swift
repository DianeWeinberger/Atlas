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
  
  @IBOutlet var imageViewHalfHeightConstraint: NSLayoutConstraint!
  @IBOutlet var imageViewFullHeightConstraint: NSLayoutConstraint!
  @IBOutlet var imageViewSquareRatioConstraint: NSLayoutConstraint!
  @IBOutlet var imageViewWidthConstraint: NSLayoutConstraint!
  @IBOutlet var nameLabelLeadingConstraint: NSLayoutConstraint!
  @IBOutlet var nameLabelAltLeadingConstraint: NSLayoutConstraint!
  @IBOutlet var connectButtonHalfWidthConstraint: NSLayoutConstraint!
  @IBOutlet var connectButtonFullWidthConstraint: NSLayoutConstraint!
  @IBOutlet var connectButtonCenterYConstraint: NSLayoutConstraint!
  @IBOutlet var connectButtonAltTopConstraint: NSLayoutConstraint!
  @IBOutlet var nameBottomConstraint: NSLayoutConstraint!
  @IBOutlet var nameTopAltConstraint: NSLayoutConstraint!
  @IBOutlet var totalMilesTrailingConstraint: NSLayoutConstraint!
  @IBOutlet var totalMilesAltLeadingConstraint: NSLayoutConstraint!
  @IBOutlet var totalMilesYConstraint: NSLayoutConstraint!
  @IBOutlet var totalMilesAltYConstraint: NSLayoutConstraint!
  
  
  
  
  var user = Variable<User>(User())
  var imageHeight: CGFloat = 0
  
  var imageIsHalfSized: Bool {
    return imageView.frame.size.height == imageHeight / 2
  }
  
  var imageIsThreeQuartedSizedOrSmaller: Bool {
    return connectButton.frame.origin.y <= 25 + imageHeight / 5 * 4
  }
  
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
    imageHeight = self.imageView.bounds.size.height
    
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
    
    setUpCollapsibleHeader()
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    imageHeight = self.imageView.bounds.size.height
  }
}

extension UserDetailViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    let width = tableView.bounds.width
    return width * 80/375
  }
}

extension UserDetailViewController: HeaderCollapsible {
  var defaultTable: UITableView {
    return activityTableView
  }
  
  func onScrollUp(displacement: CGFloat) {
    guard self.connectButton.tag == 0,       // Prevent running code during animation
      !self.imageIsHalfSized else { return } // No need to run code when segmented control is at top
    
    if self.imageIsThreeQuartedSizedOrSmaller {
      self.connectButton.tag = 1
      
      OperationQueue.main.addOperation {
        self.changeLayout(primary: false)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
          self.nameLabel.textColor = Colors.darkGray
          self.totalDistanceLabel.textColor = Colors.darkGray

          self.view.layoutIfNeeded()
        }) { (complete) in
          self.connectButton.tag = 0
          self.imageViewFullHeightConstraint.constant = 0
        }
      }
    } else {
      self.imageViewFullHeightConstraint.constant -= (displacement / 500)
    }
 
  }
  
  func onScrollDown(displacement: CGFloat) {
    if self.imageViewHalfHeightConstraint.isActive  {
      self.imageView.tag = 1
    }
    
    
    if self.imageView.tag == 1 {
      self.imageViewHalfHeightConstraint.constant -= displacement / 5
    } else {
      self.imageViewFullHeightConstraint.constant += abs(self.activityTableView.contentOffset.y) / (667/153)
    }
  }
  
  func onRelease() {
    if !imageViewHalfHeightConstraint.isActive {

      self.changeLayout(primary: true)
      
      UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
        self.nameLabel.textColor = Colors.white
        self.totalDistanceLabel.textColor = Colors.white
        
        self.view.layoutIfNeeded()
      }) { (complete) in
        self.imageView.tag = 0
      }
      
    }
  }
  
  
  // TODO: Refactor this. Rename constraints to be easier to read.
  func changeLayout(primary: Bool) {
    swap(imageViewFullHeightConstraint, imageViewHalfHeightConstraint)
    swap(imageViewWidthConstraint, imageViewSquareRatioConstraint)
    swap(nameLabelLeadingConstraint, nameLabelAltLeadingConstraint)
    swap(connectButtonHalfWidthConstraint, connectButtonFullWidthConstraint)
    swap(nameBottomConstraint, nameTopAltConstraint)
    swap(connectButtonCenterYConstraint, connectButtonAltTopConstraint)
    swap(totalMilesYConstraint, totalMilesAltYConstraint)
    swap(totalMilesTrailingConstraint, totalMilesAltLeadingConstraint)

    
    self.imageViewFullHeightConstraint.constant = 0
    self.imageViewHalfHeightConstraint.constant = 0
    self.imageViewWidthConstraint.constant = 0
    self.imageViewSquareRatioConstraint.constant = 0
    self.connectButtonFullWidthConstraint.constant = 0
    self.connectButtonHalfWidthConstraint.constant = 0
    
    self.connectButton.layer.cornerRadius = primary ? 20 : 0
  }
  
  func swap(_ a: NSLayoutConstraint, _ b: NSLayoutConstraint) {
    a.isActive = !a.isActive
    b.isActive = !a.isActive
  }
}
