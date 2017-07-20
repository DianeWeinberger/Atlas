//
//  RunViewModel.swift
//  Atlas
//
//  Created by Magfurul Abeer on 7/20/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import Foundation
import RxSwift
import Action
import CoreLocation
import Dotzu

struct RunViewModel {
  
  var coordinator: CoordinatorType
  let locationManager = CLLocationManager()
  let bag = DisposeBag()
  
  // MARK: Input
  
  // MARK: Output
  let currentLocation = Variable<CLLocation>(CLLocation())
  
  // MARK: Actions
  lazy var pauseAction: Action<Void, Void> = { this in
    return Action { _ in
      this.locationManager.stopUpdatingLocation()
      return Observable.empty()
    }
  }(self)
  

  // MARK: Init
  init(coordinator: CoordinatorType) {
    self.coordinator = coordinator
    
    locationManager.rx.didUpdateLocations
      .map { $0[0] }
//      .do(onNext: { print("Lat:\($0.coordinate.latitude)\n\($0.coordinate.longitude)") })
//      .filter { $0.horizontalAccuracy < kCLLocationAccuracyBest }
      .bind(to: currentLocation)
      .addDisposableTo(bag)

  }
  
  // MARK: Methods
  func requestAuthorization() {
    self.locationManager.requestWhenInUseAuthorization()
  }
  
  func startLocationManager() {
    
    self.locationManager.startUpdatingLocation()
  }
  
  func stopLocationManager() {
    self.locationManager.stopUpdatingLocation()
  }
  
  func pauseButtonWasLongPress(longPressGestureRecognizer: UILongPressGestureRecognizer) {
    coordinator.pop()
  }
  
}
