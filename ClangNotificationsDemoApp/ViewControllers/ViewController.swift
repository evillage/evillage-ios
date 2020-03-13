//
//  ViewController.swift
//  ClangNotificationsDemoApp
//
//  Created by Tetiana Padalko on 10/11/2019.
//  Copyright © 2019 Worth Internet Systems. All rights reserved.
//

import UIKit
import CoreLocation
import ClangNotifications

/// Tag to used in debug prints for easy search in Xcode debug console
private let logTag = "\(ViewController.self)"

class ViewController: UIViewController {
  let locationManager = CLLocationManager()

  override func viewDidLoad() {
    super.viewDidLoad()
    locationManager.delegate = self

    locationManager.requestWhenInUseAuthorization()
    // after showing the permission dialog, the program will continue executing the next line before the user has tap 'Allow' or 'Disallow'

    // if previously user has allowed the location permission, then request location
    if CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways {
      locationManager.requestLocation()
    }
  }

  @IBAction func registerAccount(_ sender: UIButton) {
    self.showDefaultAlert(title: "Thanks for registering with us", message: "🤩")
  }

  @IBAction func shareLocation(_ sender: UIButton) {
    retrieveCurrentLocation()
  }

  private func retrieveCurrentLocation() {
    let status = CLLocationManager.authorizationStatus()

    if status == .denied || status == .restricted || !CLLocationManager.locationServicesEnabled() {
      self.showDefaultAlert(title: "Oopsie", message: "You need to enable location usage for this app in settings")
      return
    }

    if status == .notDetermined {
      locationManager.requestWhenInUseAuthorization()
      return
    }

    locationManager.requestLocation()
  }
}

extension ViewController: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    print("\(logTag): location manager authorization status changed")
    if status == .authorizedWhenInUse || status == .authorizedAlways {
      manager.requestLocation()
    }
  }

  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    for location in locations {
      let logData = ["latitude": location.coordinate.latitude.description,
                     "longitude": location.coordinate.longitude.description]

      Clang().logEvent(event: "LOCATION_SHARE", data: logData) { (error) in
        guard error == nil else {
          print("\(logTag): \(error!)")
          self.showDefaultAlert(title: "Oopsie", message: error!.localizedDescription)
          return
        }

        print("\(logTag): LOCATION: ", logData["latitude"] ?? "", logData["longitude"] ?? "")
        self.showDefaultAlert(title: "Thanks, now we know where you are!", message: "🕵️")
      }
    }
  }

  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    // might be that user didn't enable location service on the device
    // or there might be no GPS signal inside a building

    // might be a good idea to show an alert to user to ask them to walk to a place with GPS signal
    print("\(logTag): Error getting location \(error.localizedDescription)")
  }
}
