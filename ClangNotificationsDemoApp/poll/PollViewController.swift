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

    @IBOutlet weak var answer: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func pollAnsweEvent(_ sender: UIButton) {
        let userAnswer = answer.text!
         let eventData = ["answer": userAnswer]

        Clang().logEvent(event: "POLL", data: eventData) { (error) in
            if error != nil {
                print(error!)
                return
            } else {
                print("Sent event!")
                return
            }
        }
    }

}
