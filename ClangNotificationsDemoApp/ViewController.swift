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

class ViewController: UIViewController {
    
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        
          locationManager.requestWhenInUseAuthorization()
          // after showing the permission dialog, the program will continue executing the next line before the user has tap 'Allow' or 'Disallow'
          
          // if previously user has allowed the location permission, then request location
          if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways){
              locationManager.requestLocation()
          }
    }

    @IBAction func registerAccount(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Thanks for registering with us", message: "🤩", preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func shareLocation(_ sender: UIButton) {
        retriveCurrentLocation()
    }
    
    private func retriveCurrentLocation() {
           let status = CLLocationManager.authorizationStatus()

           if(status == .denied || status == .restricted || !CLLocationManager.locationServicesEnabled()){
               let alertController = UIAlertController(title: "Oopsie", message: "You need to enable location usage for this app in seetings", preferredStyle: UIAlertController.Style.alert)
               alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
               present(alertController, animated: true, completion: nil)
               return
           }

           if(status == .notDetermined){
               locationManager.requestWhenInUseAuthorization()
               return
           }
    
           locationManager.requestLocation()
       }
}

extension ViewController: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
      print("location manager authorization status changed")
      if(status == .authorizedWhenInUse || status == .authorizedAlways){
        manager.requestLocation()
      }
  }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        for location in locations {
            let logData = ["latitude": location.coordinate.latitude.description,
                           "longitude": location.coordinate.longitude.description]
            
            Clang().logEvent(event: "LOCATION_SHARE", data: logData) { (error) in
                if error != nil {
                    print(error!)
                    DispatchQueue.main.async {
                    let alertController = UIAlertController(title: "Oopsie", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                    }
                    return
                } else {
                    print("LOCATION: ", logData["latitude"],  logData["longitude"])
                    DispatchQueue.main.async {
let alertController = UIAlertController(title: "Thanks, now we know where you are!", message: "🕵️", preferredStyle: UIAlertController.Style.alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                    }
                    return
                }
            }
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // might be that user didn't enable location service on the device
        // or there might be no GPS signal inside a building
      
        // might be a good idea to show an alert to user to ask them to walk to a place with GPS signal
    }
}

