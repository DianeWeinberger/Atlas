//
//  HomeHeaderView.swift
//  Atlas
//
//  Created by Magfurul Abeer on 8/2/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import UIKit
import GSKStretchyHeaderView
import RxSwift
import RxCocoa
import Pastel
import TwicketSegmentedControl

class HomeHeaderView: GSKStretchyHeaderView {

  let bannerView = UIImageView()
  let logoView = UIImage()
  let segmentedControl = TwicketSegmentedControl()

  override init(frame: CGRect) {
    super.init(frame: frame)
    
    minimumContentHeight = 100
    maximumContentHeight = 300
    
    contentShrinks = true
    contentExpands = true
    
    expansionMode = GSKStretchyHeaderViewExpansionMode.immediate
    
    configureBannerView()
    configureSegmentedControl()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func configureBannerView() {
    addSubview(bannerView)
    bannerView.image = #imageLiteral(resourceName: "Cover")
    bannerView.translatesAutoresizingMaskIntoConstraints = false
    bannerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
    bannerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
    bannerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    bannerView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.6).isActive = true
  }
  
  func configureSegmentedControl() {
    addSubview(segmentedControl)
    segmentedControl.translatesAutoresizingMaskIntoConstraints = false
    segmentedControl.topAnchor.constraint(equalTo: bannerView.bottomAnchor).isActive = true
    segmentedControl.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
    segmentedControl.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
    segmentedControl.heightAnchor.constraint(equalToConstant: 44)
    
    segmentedControl.defaultTextColor = Colors.darkGray
    segmentedControl.sliderBackgroundColor = Colors.orange.orangeRed
    segmentedControl.setSegmentItems(["My Activity", "All"])
  }
}
