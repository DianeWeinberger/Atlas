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
  private let disposeBag = DisposeBag()
  
  // MARK: Input
  var pauseTap: ControlEvent<Void>!
  
  
  // MARK: Output
  
  public lazy var timeLabel: Observable<String> = {
    return self.elapsedTime
      .map { self.stringFrom(time: $0) }
  }()
  
  public lazy var distanceLabel: Observable<String> = {
    return self.distance
      .do(onNext: { miles in
        print(miles.value)
      })
      .map { "\($0.value) mi" }
  }()
  
  public lazy var currentLocation: Observable<CLLocation> = {
    return self.locationManager.rx.didUpdateLocations
      .withLatestFrom(self.isRunning.asObservable(), resultSelector: {loc, running -> ([CLLocation], Bool) in
        return (loc, running)
      })
      .filter { (loc, running) in running }
      .map { (loc, running) in loc[0] }
      .share()
//      .filter { $0.horizontalAccuracy < kCLLocationAccuracyBest }
  }()
  
  public var locations = Variable<[CLLocation]?>(nil)
  
  
  
  // MARK: Private Observables
  
  private lazy var distance: Observable<Measurement<UnitLength>> = {
    typealias DistanceLocation = (totalDistance: Measurement<UnitLength>, location: CLLocation?)
    
    return self.currentLocation
      .scan((Measurement(value: 0, unit: UnitLength.miles), nil) as DistanceLocation) {
        distanceLocation, currentLocation -> DistanceLocation in
        
        
        guard let previousLocation = distanceLocation.location else {
          return (distanceLocation.totalDistance, currentLocation)
        }
        
        let distance = currentLocation.distance(from: previousLocation)
        let miles = Measurement(value: distance, unit: UnitLength.miles)
        
        let totalMiles = distanceLocation.totalDistance + miles
        
        return (totalMiles, currentLocation)
      }
      .map { distLoc -> Measurement<UnitLength> in
          return distLoc.totalDistance
      }
    
    
//    let previousLocations = self.currentLocation
//      .map { location in
//        return location as CLLocation?
//      }
//      .startWith(nil)
//    
//    return self.currentLocation
//      .withLatestFrom(previousLocations, resultSelector: { current, prev -> (CLLocation, CLLocation?) in
//        return (current, prev)
//      })
//      .map { (current, prev) -> Measurement<UnitLength> in
//        guard let previous = prev else {
//          return Measurement(value: 0, unit: UnitLength.miles)
//        }
//        let distance = current.distance(from: previous)
//        return Measurement(value: distance, unit: UnitLength.miles)
//      }
//      .scan(Measurement(value: 0, unit: UnitLength.miles), accumulator: { (accumulator, distance) -> Measurement<UnitLength> in
//        // Possibly replace with reduce
//        return accumulator + distance
//      })
//      .map { $0.value }
//      .share()
  }()
  
  private lazy var elapsedTime: Observable<Int> = {
    return Observable<Int>.interval(1, scheduler: MainScheduler.instance)
      .withLatestFrom(self.isRunning.asObservable(), resultSelector: {_, running in running})
      .filter { running in running }
      .scan(0, accumulator: { (acc, _) in acc + 1 })
      .startWith(0)
      .shareReplayLatestWhileConnected()
  }()
  
  private let isRunning = Variable<Bool>(true)
//  lazy var isRunning: Observable<Bool> = {
//    return self.pauseTap.scan(false) { last, new in !last }
//      .startWith(false)
//  }()
  
  // MARK: Action
  lazy var pauseAction: Action<Void, Void> = {
    return Action { _ in
      self.isRunning.value = !self.isRunning.value
      return Observable.empty()
    }
  }()


  
  // MARK: Init
  init(coordinator: CoordinatorType) {
    self.coordinator = coordinator
    
    // TODO: Try replacing variable with this and subscribe to it in vc and update overlay
    self.currentLocation
      .reduce([CLLocation](), accumulator: { (acc, location) -> [CLLocation] in
        return acc + [location]
      })
      .bind(to: self.locations)
      .addDisposableTo(disposeBag)
    
    self.distance
      .subscribe(onNext: { d in
        print(d)
      })
      .addDisposableTo(disposeBag)
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
