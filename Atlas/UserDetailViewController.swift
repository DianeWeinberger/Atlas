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
import Action

// TODO: Make View Model for this
class UserDetailViewController: UIViewController {
  
  // MARK: IBOutlets
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
  
  // MARK: Constraint IBOutlets
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
  
  
  // MARK: Variables
  var currentUser = Variable<User>(MockUser.ironMan)  // The user using the app. Not the user being shown
  var displayedUser = Variable<User>(User())
  var imageHeight: CGFloat = 0
  
  var imageIsHalfSized: Bool {
    return imageView.frame.size.height == imageHeight / 2
  }
  
  var imageIsThreeQuartedSizedOrSmaller: Bool {
    return connectButton.frame.origin.y <= 25 + imageHeight / 5 * 4
  }
  
  fileprivate lazy var history: Observable<[Event]> = {
    return self.displayedUser.asObservable()
      .map { $0.history.toArray() }
  }()
  
  fileprivate lazy var runs: Observable<[Run]> = {
    return self.displayedUser.asObservable()
      .map { $0.sortedRuns }
  }()
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    imageHeight = self.imageView.bounds.size.height
    
    modalPresentationCapturesStatusBarAppearance = true
    
    if let url = displayedUser.value.url {
      imageView.sd_setImage(with: url)
    }
    
    activityLabel.text = "\(displayedUser.value.firstName)'s Activity"
    nameLabel.text = displayedUser.value.displayName
    
    activityTableView.delegate = self
    
    runs
      .bind(to: activityTableView.rx.items(cellIdentifier: RunTableViewCell.reuseIdentifier, cellType: RunTableViewCell.self)) {
        row, run, cell in
        cell.configure(run: run)
      }
      .addDisposableTo(rx_disposeBag)
    
    self.connectButton.rx.tap
      .subscribe(onNext: { _ in
        self.displayedUser.value.recievedRequests.append(self.currentUser.value)
        let user = self.currentUser.value
        user.sentRequests.append(self.displayedUser.value)

        self.currentUser.value = user
      })
      .addDisposableTo(rx_disposeBag)
    
    Observable.combineLatest(currentUser.asObservable(), displayedUser.asObservable()) {
      (currentUser, displayedUser) -> UserRelationState in
      return currentUser.relation(to: displayedUser)
    }
    .subscribe(onNext: { relation in
      // TODO: Put into tuples of connect button state data
      switch relation {
      case .connect:
        self.connectButton.setTitle("CONNECT", for: .normal)
        self.connectButton.backgroundColor = Colors.orange.orangeRed
        self.connectButton.setTitleColor(Colors.white, for: .normal)
        self.connectButton.isEnabled = true
        break
      case .friend:
        self.connectButton.setTitle("FRIENDS", for: .normal)
        self.connectButton.backgroundColor = UIColor.lightGray
        self.connectButton.setTitleColor(Colors.white, for: .normal)
        self.connectButton.isEnabled = false
        break
      case .requestSent:
        self.connectButton.setTitle("REQUEST SENT", for: .normal)
        self.connectButton.backgroundColor = UIColor.lightGray
        self.connectButton.setTitleColor(Colors.white, for: .normal)
        self.connectButton.isEnabled = false
        break
      case .awaitingResponse:
        self.connectButton.setTitle("AWAITING RESPONSE", for: .normal)
        self.connectButton.backgroundColor = UIColor.lightGray
        self.connectButton.setTitleColor(Colors.white, for: .normal)
        self.connectButton.isEnabled = false
        break
      }
    })
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
          self.paceLabel.isHidden = true
          self.locationLabel.isHidden = true
          self.expertiseLabel.isHidden = true
          self.runnerTypeLabel.isHidden = true
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
    resetConstants()
    
    if !imageViewHalfHeightConstraint.isActive {
      
      changeLayout(primary: true)
      
      UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
        self.nameLabel.textColor = Colors.white
        self.totalDistanceLabel.textColor = Colors.white
        self.paceLabel.isHidden = false
        self.locationLabel.isHidden = false
        self.expertiseLabel.isHidden = false
        self.runnerTypeLabel.isHidden = false

        self.view.layoutIfNeeded()
      }) { (complete) in
        self.imageView.tag = 0
      }
      
    }
  }
  
  // TODO: Refactor this. Rename constraints to be easier to read.
  func changeLayout(primary: Bool) {
    resetConstants()
    self.connectButton.layer.cornerRadius = primary ? 20 : 0
    
    guard primary != imageViewFullHeightConstraint.isActive else { return }
    
    let swap: (NSLayoutConstraint, NSLayoutConstraint) -> Void = {
      (_ a: NSLayoutConstraint, _ b: NSLayoutConstraint) in
      a.isActive = !a.isActive
      b.isActive = !a.isActive
    }
    
    
    swap(imageViewFullHeightConstraint, imageViewHalfHeightConstraint)
    swap(imageViewWidthConstraint, imageViewSquareRatioConstraint)
    swap(nameLabelLeadingConstraint, nameLabelAltLeadingConstraint)
    swap(connectButtonHalfWidthConstraint, connectButtonFullWidthConstraint)
    swap(nameBottomConstraint, nameTopAltConstraint)
    swap(connectButtonCenterYConstraint, connectButtonAltTopConstraint)
    swap(totalMilesYConstraint, totalMilesAltYConstraint)
    swap(totalMilesTrailingConstraint, totalMilesAltLeadingConstraint)

  }
  
  func resetConstants() {
    self.imageViewFullHeightConstraint.constant = 0
    self.imageViewHalfHeightConstraint.constant = 0
    self.imageViewWidthConstraint.constant = 0
    self.imageViewSquareRatioConstraint.constant = 0
    self.connectButtonFullWidthConstraint.constant = 0
    self.connectButtonHalfWidthConstraint.constant = 0
    
  }
}
