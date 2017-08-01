//
//  RunTableViewCell.swift
//  Atlas
//
//  Created by Magfurul Abeer on 8/1/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import UIKit

class RunTableViewCell: UITableViewCell {

  @IBOutlet weak var dayLabel: UILabel!
  @IBOutlet weak var monthLabel: UILabel!
  @IBOutlet weak var locationLabel: UILabel!
  @IBOutlet weak var distanceLabel: UILabel!
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var paceLabel: UILabel!
  @IBOutlet weak var calendarView: UIView!
  
  func configure(run: Run) {
    dayLabel.text = "\(run.timestamp.day)"
    monthLabel.text = "\(run.timestamp.month)"
    timeLabel.text = "\(run.time)"
    distanceLabel.text = "\(run.distance)"
    paceLabel.text = "\(run.pace)"
    
    calendarView.layer.borderColor = UIColor(253, 99, 40).cgColor
    calendarView.layer.borderWidth = 1
    calendarView.layer.cornerRadius = calendarView.bounds.height * 4/41.4
    calendarView.layer.masksToBounds = true
  }
}
