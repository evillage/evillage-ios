//
//  AppDelegate+RemoteNotificationsExtension.swift
//  ClangNotificationsDemoApp
//
//  Created by Sebastiaan Seegers on 13/03/2020.
//  Copyright © 2020 Worth Internet Systems. All rights reserved.
//

import Firebase
import Foundation
import ClangNotifications

extension AppDelegate: UNUserNotificationCenterDelegate {
  func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
    print("Did receive: ", response)

    Clang().logNotification(notificationId: "EVillageDemo", actionId: response.actionIdentifier) { error in
      guard error == nil else {
        print("AppDelegate+NotificationExtension: PANIC \(error!)")
        return
      }
      print("AppDelegate+NotificationExtension: Successfully logged notification")
      return
    }
    completionHandler()
  }
}

extension AppDelegate: MessagingDelegate {

  func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    Messaging.messaging().apnsToken = deviceToken
  }

  /// When the application received a remote notification this delegate method will fire
  /// - Parameters:
  ///   - application: The centralized point of control and coordination for apps running in iOS.
  ///   - userInfo: The userInfo containing the payload of the remote notification
  func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
    print("AppDelegate+NotificationExtension: Remote Message \(userInfo)")
  }

  /// Tells the app that a remote notification arrived that indicates there is data to be fetched.
  /// - Parameters:
  ///   - application: Your singleton app object.
  ///   - userInfo: The payload of the remote notification
  ///   - completionHandler: The block to execute when the download operation is complete
  func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    print("AppDelegate+NotificationExtension: Remote Message \(userInfo)")
  }

  /// Firebase messaging delegate for receiving FCM token
  /// - Parameters:
  ///   - messaging: The messaging object from Firebase
  ///   - fcmToken: The FCM token we need to register our device with
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
    InstanceID.instanceID().instanceID { result, error in
      guard error == nil, let result = result else {
        print("AppDelegate+NotificationExtension: \(String(describing: error?.localizedDescription)) or result is nil")
        return
      }

      Clang().registerAccount(firebaseToken: result.token) { userId, error in
        guard error == nil else {
          print("AppDelegate+NotificationExtension: \(error!)")
          return
        }
        print("AppDelegate+NotificationExtension: USER IS \(userId)")
      }

      //        Clang().updateTokenOnServer(firebaseToken: result.token) { error in
      //          guard error == nil else {
      //            print("AppDelegate+NotificationExtension: \(error!)")
      //            return
      //          }
      //          print("AppDelegate+NotificationExtension: SUCCESSFULLY UPDATED TOKEN!")
      //          return
      //        `}
    }
  }
}

extension AppDelegate {

  /// Register the device to receive remote notifications
  /// Setup Firebase Messaging delegate
  /// Register the application for remote notifications
  /// Set the UNUserNotificationsCenter Delegate
  /// - Parameter application: The centralized point of control and coordination for apps running in iOS.
  func registerForPushNotifications(_ application: UIApplication) {
    Messaging.messaging().delegate = self

    if #available(iOS 10.0, *) {
      // For iOS 10 display notification (sent via APNS)
      UNUserNotificationCenter.current().delegate = self
      let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
      UNUserNotificationCenter.current().requestAuthorization( options: authOptions, completionHandler: {_, _ in })

      let likeAction = UNNotificationAction(identifier: "like_action", title: "Like", options: UNNotificationActionOptions(rawValue: 0))
      let dislikeAction = UNNotificationAction(identifier: "dislike_action", title: "Dislike", options: UNNotificationActionOptions(rawValue: 0))
      let dismissAction = UNNotificationAction(identifier: "dismiss_action", title: "Dismiss", options: UNNotificationActionOptions(rawValue: 0))
      let clangCategory = UNNotificationCategory(identifier: "clang", actions: [likeAction, dislikeAction, dismissAction], intentIdentifiers: [])

      UNUserNotificationCenter.current().setNotificationCategories([clangCategory])

      // For iOS 10 data message (sent via FCM)
    } else {
      let settings: UIUserNotificationSettings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
      application.registerUserNotificationSettings(settings)
    }
    application.registerForRemoteNotifications()
    updateFCMToken()
  }

  /// Update the FCM token and re-register with Clang
  func updateFCMToken() {
    guard let token = Messaging.messaging().fcmToken else {
      print("AppDelegate+NotificationExtension: FCM token is empty!")
      return
    }
    print("AppDelegate+NotificationExtension: FB TOKEN: \(token)")
    Clang().registerAccount(firebaseToken: token) { userId, error in
      guard error == nil else {
        print("AppDelegate: \(error!)")
        return
      }

      print("AppDelegate+NotificationExtension: USER IS: \(userId ?? "")")
    }
  }
}
