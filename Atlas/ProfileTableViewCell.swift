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

class ProfileTableViewCell: UITableViewCell {
  
  @IBOutlet weak var profileImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var locationLabel: UILabel!
  @IBOutlet weak var paceLabel: UILabel!
//  @IBOutlet weak var paceBlock: StatBlock!
//  @IBOutlet weak var distanceBlock: StatBlock!
  
  @IBOutlet weak var statsCollectionView: UICollectionView!
  
  static let identifier = "PROFILE_TABLEVIEW_CELL"
  
  override func awakeFromNib() {
    super.awakeFromNib()
    // Initialization code
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    // Configure the view for the selected state
  }
  
  func configure(from user: User) {
    if let url = user.url {
      let dimension = self.profileImageView.bounds.width
      self.profileImageView.sd_setImage(with: url, placeholderImage: #imageLiteral(resourceName: "deadpool"))
      self.profileImageView.layer.cornerRadius = dimension / 2
      self.profileImageView.layer.masksToBounds = true
      self.profileImageView.layer.borderWidth = 7
      self.profileImageView.layer.borderColor = Colors.orange.orangeRed.cgColor
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
