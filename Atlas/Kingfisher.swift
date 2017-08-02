//
//  Kingfisher.swift
//  Atlas
//
//  Created by Magfurul Abeer on 8/2/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import Foundation
import Kingfisher

extension Kingfisher where Base: ImageView {
  func roundedImage(with url: URL) {
    let options: KingfisherOptionsInfo = [
      .transition(.fade(0.2))
    ]
    
    self.setImage(with: url, placeholder: nil, options: options, progressBlock: nil) {
      (image, error, cache, url) in
      
      let imageView = self.base as UIImageView
      imageView.maskCircle()
    }
  }
}

extension UIImageView {
  public func maskCircle() {
    self.contentMode = UIViewContentMode.scaleAspectFill
    self.layer.cornerRadius = self.bounds.height / 2
    self.layer.masksToBounds = false
    self.clipsToBounds = true
  }
}
