//
//  AppDelegate.swift
//  ClangNotificationsDemoApp
//
//  Created by Tetiana Padalko on 10/11/2019.
//  Copyright © 2019 Worth Internet Systems. All rights reserved.
//

import UIKit
import Firebase
import ClangNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  // iOS 12 fix
  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    FirebaseApp.configure()
    registerForPushNotifications(application)
    registerNotificationCategories()
    return true
  }
    
    private func registerNotificationCategories() {
        let openBoardAction = UNNotificationAction(identifier: UNNotificationDefaultActionIdentifier, title: "Open Board", options: UNNotificationActionOptions.foreground)
        let contentAddedCategory = UNNotificationCategory(identifier: "content_added_notification", actions: [openBoardAction], intentIdentifiers: [], hiddenPreviewsBodyPlaceholder: "", options: .customDismissAction)
        UNUserNotificationCenter.current().setNotificationCategories([contentAddedCategory])
    }

  // MARK: UISceneSession Lifecycle

  @available(iOS 13.0, *)
  func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }

  @available(iOS 13.0, *)
  func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
  }
}
