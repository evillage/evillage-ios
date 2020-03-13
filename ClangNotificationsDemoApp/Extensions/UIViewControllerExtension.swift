//
//  UIViewControllerExtension.swift
//  ClangNotificationsDemoApp
//
//  Created by Sebastiaan Seegers on 13/03/2020.
//  Copyright © 2020 Worth Internet Systems. All rights reserved.
//

import UIKit
import Foundation

extension UIViewController {

  /// Show a default alert on the UIViewController and make sure it's shown on UI thread
  /// - Parameters:
  ///   - title: The title of the alert
  ///   - message: The message of the alert
  func showDefaultAlert(title: String, message: String) {
    DispatchQueue.main.async {
      let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
      alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
      self.present(alertController, animated: true, completion: nil)
    }
  }
}
