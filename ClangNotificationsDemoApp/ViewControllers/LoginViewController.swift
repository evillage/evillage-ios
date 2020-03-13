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
    let userEmail = email.text!
    let eventData = ["email": userEmail]

    Clang().logEvent(event: "LOGIN", data: eventData) { error in
      guard error == nil else {
        print("\(logTag): \(error!)")
        return
      }
      print("\(logTag): Sent event!")
      return
    }
  }
}
