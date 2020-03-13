//
//  PollViewController.swift
//  ClangNotificationsDemoApp
//
//  Created by Tetiana Padalko on 10/11/2019.
//  Copyright © 2019 Worth Internet Systems. All rights reserved.
//

import UIKit
import ClangNotifications

/// Tag to used in debug prints for easy search in Xcode debug console
private let logTag = "\(PollViewController.self)"

class PollViewController: UIViewController {
  @IBOutlet weak var answer: UITextField!

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }

  @IBAction func pollAnsweEvent(_ sender: UIButton) {
    let userAnswer = answer.text!
    let eventData = ["answer": userAnswer]

    Clang().logEvent(event: "POLL", data: eventData) { error in
      guard error == nil else {
        print("\(logTag): \(error!)")
        return
      }
      print("\(logTag): Sent event!")
      return
    }
  }
}
