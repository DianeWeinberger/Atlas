//
//  StatBlockCollectionViewCell.swift
//  Atlas
//
//  Created by Magfurul Abeer on 7/31/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import UIKit

class StatBlockCollectionViewCell: UICollectionViewCell {
  
  @IBOutlet weak var qualifierLabel: UILabel!
  @IBOutlet weak var statLabel: UILabel!
  @IBOutlet weak var valueLabel: UILabel!
  
  func configure(block: StatBlock) {
    qualifierLabel.text = block.qualifier
    statLabel.text = block.stat
    valueLabel.text = block.value
    
    layer.cornerRadius = 16/103 * bounds.height
    layer.borderWidth = 3
    layer.borderColor = Colors.pauseBlue.cgColor
    layer.backgroundColor =  Colors.pauseBlueLight.cgColor
  }
}

typealias StatBlock = (qualifier: String, stat: String, value: String)
