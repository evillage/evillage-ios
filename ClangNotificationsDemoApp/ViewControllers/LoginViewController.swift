//
//  LoginViewController.swift
//  ClangNotificationsDemoApp
//
//  Created by Tetiana Padalko on 10/11/2019.
//  Copyright © 2019 Worth Internet Systems. All rights reserved.
//

import UIKit
import ClangNotifications

/// Tag to used in debug prints for easy search in Xcode debug console
private let logTag = "\(LoginViewController.self)"

class LoginViewController: UIViewController {
  @IBOutlet weak var email: UITextField!

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }

  @IBAction func loginEvent(_ sender: UIButton) {
    let userEmail = "Jeffrey@livecast.nl"
    let eventData = ["email": userEmail]

    Clang().logEvent(eventName: "LOGIN", eventData: eventData) { error in
      guard error == nil else {
        print("\(logTag): \(error!)")
        return
      }
      print("\(logTag): Sent event!")
      let alertAction = UIAlertAction(title: "OK", style: .default) { _ in
        self.dismiss(animated: true, completion: nil)
      }
      self.showDefaultAlert(title: "Login successfull", message: "You've successfully logged in!", alertActions: [alertAction])
    }
  }
}
