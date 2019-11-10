//
//  PushNotificationManager.swift
//  ClangNotificationsDemoApp
//
//  Created by Tetiana Padalko on 10/11/2019.
//  Copyright © 2019 Worth Internet Systems. All rights reserved.
//

import ClangNotifications
import Foundation
import Firebase
import FirebaseMessaging
import UIKit
import UserNotifications

class PushNotificationManager: NSObject, MessagingDelegate, UNUserNotificationCenterDelegate {

    override init() {
            super.init()
        }

        public func registerForPushNotifications() {
            if #available(iOS 10.0, *) {
                // For iOS 10 display notification (sent via APNS)
                UNUserNotificationCenter.current().delegate = self
                let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
                UNUserNotificationCenter.current().requestAuthorization(
                    options: authOptions,
                    completionHandler: {_, _ in })
                // For iOS 10 data message (sent via FCM)
                Messaging.messaging().delegate = self
            } else {
                let settings: UIUserNotificationSettings =
                    UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
                UIApplication.shared.registerUserNotificationSettings(settings)
            }
            UIApplication.shared.registerForRemoteNotifications()
            updateFirestorePushTokenIfNeeded()
        }
    
        func updateFirestorePushTokenIfNeeded() {
            if let token = Messaging.messaging().fcmToken {
                print("FB TOKEN: ", token)
                Clang().registerAccount(firebaseToken: token) { (userId, error) in
                    if error != nil {
                        print(error!)
                        return
                    } else {
                        print("USER IS: ", userId!)
                        return
                    }
                }
            }
        }
        func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
            print("Remote Message: ", remoteMessage.appData)
        }
        func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
            updateFirestorePushTokenIfNeeded()
        }
        func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
            print("Did receive: ", response)
        }
    }

