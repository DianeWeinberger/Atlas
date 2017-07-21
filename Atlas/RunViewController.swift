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
    
    viewModel.timeLabel
      .subscribeOn(MainScheduler.instance)
      .subscribe(onNext: { time in
        self.timeLabel.text = time
      })
      .addDisposableTo(rx_disposeBag)
    
    viewModel.distanceLabel
      .subscribeOn(MainScheduler.instance)
      .subscribe(onNext: { distance in
        self.distanceLabel.text = distance
        self.mapView.add(self.polyLine())
      })
      .addDisposableTo(rx_disposeBag)
    
    
  }
  
}

extension RunViewController {
  func bindViewModel() {
    
    viewModel.requestAuthorization()
    viewModel.pauseTap = pauseButton.rx.tap
    
    viewModel.currentLocation.asObservable()
      .skip(1)
      .subscribe(onNext: { location in
        
        if (location.horizontalAccuracy <= kCLLocationAccuracyNearestTenMeters) {
          Whisper.show(shout: Announcement(title: "Accurate Location"), to: self)
        }
        let span = MKCoordinateSpan(latitudeDelta: 10, longitudeDelta: 10)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        self.mapView.setRegion(region, animated: true)
      })
      .addDisposableTo(rx_disposeBag)
    

    viewModel.startLocationManager()
  }
  
  
  fileprivate func polyLine() -> MKPolyline {
    guard let locations = viewModel.locations.value else {
      return MKPolyline()
    }
    
    let coords: [CLLocationCoordinate2D] = locations.map { location in
      let coordinate = location.coordinate
      return CLLocationCoordinate2D(latitude: coordinate.latitude, longitude: coordinate.longitude)
    }
    return MKPolyline(coordinates: coords, count: coords.count)
  }
    
}

extension RunViewController: MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
    guard let polyline = overlay as? MKPolyline else {
      return MKOverlayRenderer(overlay: overlay)
    }
    let renderer = MKPolylineRenderer(polyline: polyline)
    renderer.strokeColor = .black
    renderer.lineWidth = 3
    return renderer
  }
}
