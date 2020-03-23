//
//  PollViewController.swift
//  ClangNotificationsDemoApp
//
//  Created by Tetiana Padalko on 10/11/2019.
//  Copyright © 2019 Worth Internet Systems. All rights reserved.
//

import UIKit
import ClangNotifications

class PollViewController: UIViewController {
  /// Tag to used in debug prints for easy search in Xcode debug console
  private let logTag = "\(PollViewController.self)"

  @IBOutlet weak var answer: UITextField!

  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }

  @IBAction func pollAnsweEvent(_ sender: UIButton) {
    let userAnswer = answer.text!
    let eventData = ["answer": userAnswer]

    Clang().logEvent(eventName: "POLL", eventData: eventData) { error in
      guard error == nil else {
        print("\(self.logTag): \(error!)")
        return
      }
      print("\(self.logTag): Sent event!")
      let alertAction = UIAlertAction(title: "OK", style: .default) { _ in
        self.dismiss(animated: true, completion: nil)
      }

      self.showDefaultAlert(title: "Poll answered", message: "Yay you've answered the poll, have a 🍪", alertActions: [alertAction])
    }
  }
}
