//
//  ProfileTableViewCell.swift
//  Atlas
//
//  Created by Magfurul Abeer on 7/31/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SDWebImage
import AvatarImageView
import Kingfisher

class ProfileTableViewCell: UITableViewCell {
  
  @IBOutlet weak var profileImageView: AvatarImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var locationLabel: UILabel!
  @IBOutlet weak var editButton: UIButton!
  @IBOutlet weak var logoutButton: UIButton!
  @IBOutlet weak var statsCollectionView: UICollectionView!
  
  static let identifier = "PROFILE_TABLEVIEW_CELL"
  
  func configure(from user: User) {
    
    self.profileImageView.configuration = AvatarConfig.shared
    self.profileImageView.dataSource = user.avatarData
    if !user.imageURL.isEmpty, let url = user.url {
      self.profileImageView.kf.roundedImage(with: url)
    }
    
    self.nameLabel.text = user.fullName
    
    DispatchQueue.once(token: "SET_STAT_COLLECTION_VIEW_DELEGATE") { [weak self] in
      guard let this = self else { return }
      
      this.statsCollectionView.rx.setDelegate(this).addDisposableTo(this.rx_disposeBag)
      
      Observable.of(user)
        .flatMap { user in user.stats }
        .bind(to: this.statsCollectionView.rx.items(cellIdentifier: StatBlockCollectionViewCell.reuseIdentifier, cellType: StatBlockCollectionViewCell.self)) {
          row, statBlock, cell in
          cell.configure(block: statBlock)
        }
        .addDisposableTo(this.rx_disposeBag)
    }
    
  }
}

extension ProfileTableViewCell: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let width = collectionView.bounds.width
    let cellWidth = (width - 15) / 2
    let cellHeight = 103/167 * cellWidth
    return CGSize(width: cellWidth, height: cellHeight)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 10
  }
}



