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

class MainViewController: UIViewController {
  /// Tag to used in debug prints for easy search in Xcode debug console
  private let logTag = "\(MainViewController.self)"

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
    
    
      Environment.integrationId = "INTEGRATION_ID provided"
      Environment.authorizationToken = "AUTHORIZATION_TOKEN provided"
  }
    
    @IBAction func buildTicket(_ sender: UIButton) {
        
    
        //let htmlString = "<!DOCTYPE html><html><head><meta name=\"viewport\"content=\"width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=no\"/><link href=\"https://fonts.googleapis.com/css?family=PT+Sans:400,700\" rel=\"stylesheet\"><style>table {width:100%;font-size:17px;font-family:PT Sans,Helvetica,Arial,sans-serif;color:#003b5a;line-height:24px;}.title{font-size:20px;}.button{text-align:left;color:#00a4a7;font-weight:bold;text-decoration:none;}</style></head><body style=\"background-color:transparent;\"><table><tr><td><table><tr><td width=\"40px;\"><img src=\"https://i.ibb.co/ggbFyTT/Asset-360-10-R.png\" width=\"35px\"></td><td class=\"title\"><b>Particuliere rekening openen</b></td></tr></table></td></tr><tr><td>Naast zakelijk ook privé bij ons bankieren? Druk in de Knab App op het plusje rechtsboven en kies voor ‘betaalrekening’. Stap nu over en ontvang € 50!</td><tr><td class=\"button\"></td></tr></tr></table></body></html>"
        
        //ClangFunctions().buildTheTickets(parent: self, toAdd: htmlString)
    }

  @IBAction func registerAccount(_ sender: UIButton) {
    guard let firebaseToken = (UIApplication.shared.delegate as? AppDelegate)?.getFirebaseToken() else {
      print("\(self.logTag): Error FirebaseToken is nil!")
      return
    }

    Clang().registerAccount(fcmToken: firebaseToken) { id, error in
      guard error == nil else {
        print("\(self.logTag): \(error!)")
        self.showDefaultAlert(title: "Sorry", message: "There was an error registering you're account! Please try again later")
        return
      }

      print("Successfully performend API Call userID = \(id ?? "")")
      self.showDefaultAlert(title: "Thanks for registering with us", message: "Your userId = \(id ?? "")")
    }
  }

  @IBAction func shareLocation(_ sender: UIButton) {
    let status = CLLocationManager.authorizationStatus()
    if status == .denied || status == .restricted || !CLLocationManager.locationServicesEnabled() {
      self.showDefaultAlert(title: "Sorry", message: "You need to enable location usage for this app in settings")
      return
    }

    if status == .notDetermined {
      locationManager.requestWhenInUseAuthorization()
      return
    }

    locationManager.requestLocation()
  }

  @IBAction func setProperty(_ sender: UIButton) {
    Clang().updateProperties(data: ["Pizza": "Calzone"]) { error in
      guard error == nil else {
        print("\(self.logTag): \(error!)")
        self.showDefaultAlert(title: "Sorry", message: "Failed to set property with error: \(error!)")
        return
      }

      print("Successfully performed API call!")
      self.showDefaultAlert(title: "Properties updated", message: "Properties successfully updated")
    }
  }
}

extension MainViewController: CLLocationManagerDelegate {
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

      Clang().logEvent(eventName: "LOCATION_SHARE", eventData: logData) { (error) in
        guard error == nil else {
          print("\(self.logTag): \(error!)")
          self.showDefaultAlert(title: "Oopsie", message: error!.localizedDescription)
          return
        }

        print("\(self.logTag): LOCATION: ", logData["latitude"] ?? "", logData["longitude"] ?? "")
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
