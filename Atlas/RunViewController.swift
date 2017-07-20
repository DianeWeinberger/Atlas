//
//  RunViewController.swift
//  Atlas
//
//  Created by Magfurul Abeer on 7/20/17.
//  Copyright © 2017 Magfurul Abeer. All rights reserved.
//

import UIKit
import MapKit
import Dotzu
import Whisper

import RxSwift
import RxCocoa
import Action
import RxGesture

class RunViewController: UIViewController, BindableType {
  
  @IBOutlet weak var mapView: MKMapView!
  @IBOutlet weak var timeLabel: UILabel!
  @IBOutlet weak var distanceLabel: UILabel!
  @IBOutlet weak var paceLabel: UILabel!
  @IBOutlet weak var pauseButton: UIButton!
  
  var viewModel: RunViewModel!

  override func viewDidLoad() {

    mapView.showsUserLocation = true
    
    pauseButton.rx.action = viewModel.pauseAction
    
    pauseButton.rx.longPressGesture()
      .when(UIGestureRecognizerState.began)
      .subscribe(onNext: viewModel.pauseButtonWasLongPress)
      .addDisposableTo(rx_disposeBag)
    
    viewModel.elapsedTime.asObservable()
      .subscribe(<#T##on: (Event<String>) -> Void##(Event<String>) -> Void#>)
  }
  
  func bindViewModel() {
    
    viewModel.requestAuthorization()
    
    viewModel.currentLocation.asObservable()
      .skip(1)
      .subscribe(onNext: { location in
        
        if (location.horizontalAccuracy < kCLLocationAccuracyThreeKilometers) {
          
          Whisper.show(shout: Announcement(title: "Accurate Location"), to: self)
        }
        print("Lat:\(location.coordinate.latitude)\n\(location.coordinate.longitude)")
        let span = MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        self.mapView.setRegion(region, animated: true)
      })
      .addDisposableTo(rx_disposeBag)
    

    viewModel.startLocationManager()
  }
}
