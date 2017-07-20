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
  let elapsedTime = Variable<String>("0:00:00")
  
  private let isRunning = Variable<Bool>(true)
  private let timer = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
  
  // MARK: Actions
  lazy var pauseAction: Action<Void, Void> = { this in
    return Action { _ in
      this.locationManager.stopUpdatingLocation() // Have this flip too
      this.isRunning.value = !this.isRunning.value
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
    
    timer
      .withLatestFrom(isRunning.asObservable(), resultSelector: {_, running in running})
      .filter {running in running}
      .scan(0, accumulator: {(acc, _) in
        return acc+1
      })
      .startWith(0)
      .map(stringFrom)
      .bind(to: elapsedTime)
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

  private func stringFrom(time: Int) -> String {
    let hours = Int(time) / 3600
    let minutes = Int(time) / 60 % 60
    let seconds = Int(time) % 60
    return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
  }
}
