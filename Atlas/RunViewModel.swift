//
//  RunViewModel.swift
//  Atlas
//
//  Created by Magfurul Abeer on 7/20/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Action
import CoreLocation
import Dotzu

class RunViewModel {
  
  //MARK: Properties
  private var coordinator: CoordinatorType
  private let locationManager = CLLocationManager()

  
  // MARK: Input
  var pauseTap: ControlEvent<Void>!
  
  
  // MARK: Output
  lazy var currentLocation: Observable<CLLocation> = {
    return self.locationManager.rx.didUpdateLocations
      .withLatestFrom(self.isRunning, resultSelector: {loc, running -> ([CLLocation], Bool) in
        return (loc, running)
      })
      .filter { (loc, running) in running }
      .map { (loc, running) in loc[0] }
//      .filter { $0.horizontalAccuracy < kCLLocationAccuracyBest }
  }()
  
  lazy var elapsedTime: Observable<String> = {
    return Observable<Int>.interval(1, scheduler: MainScheduler.instance)
      .withLatestFrom(self.isRunning, resultSelector: {_, running in running})
      .filter { running in running }
      .scan(0, accumulator: { (acc, _) in acc + 1 })
      .startWith(0)
      .map { self.stringFrom(time: $0) }
      .shareReplayLatestWhileConnected()
  }()
  
  lazy var isRunning: Observable<Bool> = {
    return self.pauseTap.scan(false) { last, new in !last }
      .startWith(false)
  }()
  
  // MARK: Init
  init(coordinator: CoordinatorType) {
    self.coordinator = coordinator
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
    self.locationManager.stopUpdatingLocation()
    coordinator.pop()
  }

  private func stringFrom(time: Int) -> String {
    let hours = Int(time) / 3600
    let minutes = Int(time) / 60 % 60
    let seconds = Int(time) % 60
    return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
  }
}
