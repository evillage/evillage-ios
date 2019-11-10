//
//  LoginViewController.swift
//  ClangNotificationsDemoApp
//
//  Created by Tetiana Padalko on 10/11/2019.
//  Copyright © 2019 Worth Internet Systems. All rights reserved.
//

import UIKit
import ClangNotifications

class LoginViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

  
    @IBAction func loginEvent(_ sender: UIButton) {
        let userEmail = email.text!
        let eventData = ["email": userEmail]

       Clang().logEvent(event: "LOGIN", data: eventData) { (error) in
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
