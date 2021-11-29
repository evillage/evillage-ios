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

    /// The delegate method that will be called when a notification is received and will log the notification to the Clang backend
    /// - Parameters:
    ///   - center: The UNUserNotificationCenter object
    ///   - response: The UNNotificationResponse object
    ///   - completionHandler: The completionHandler that needs to be called if you're done in this method
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print("Did receive: ", response)
        
        
        let userInfo = response.notification.request.content.userInfo
        let payload = userInfo["cd_payload"] as? String ?? ""
        ClangFunctions().buildTheTickets(parent: (UIApplication.shared.keyWindow?.rootViewController)!, toAdd: payload)
      
        
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

    /// UIKit calls this method after it successfully registers your app with APNs
    /// - Parameters:
    ///   - application: The app object that initiated the remote-notification registration process.
    ///   - deviceToken: A globally unique token that identifies this device to APNs. Send this token to the server that you use to generate remote notifications.
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    /// When the application received a remote notification this delegate method will fire
    /// - Parameters:
    ///   - application: The centralized point of control and coordination for apps running in iOS.
    ///   - userInfo: The userInfo containing the payload of the remote notification
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        print("AppDelegate+NotificationExtension: didReceiveRemoteNotification \(userInfo)")
    }
    
    /// Tells the app that a remote notification arrived that indicates there is data to be fetched.
    /// - Parameters:
    ///   - application: Your singleton app object.
    ///   - userInfo: The payload of the remote notification
    ///   - completionHandler: The block to execute when the download operation is complete
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("AppDelegate+NotificationExtension: Received FCM Token: \(userInfo)")
        
        let payload = userInfo["cd_payload"] as? String ?? ""
        ClangFunctions().buildTheTickets(parent: (UIApplication.shared.keyWindow?.rootViewController)!, toAdd: payload)
      
        if Clang().isClangNotification(userInfo: userInfo) {
            do {
                let notification = try Clang().createNotification(userInfo: userInfo)
                print("Got notification from Clang with id \(notification.id), title \"\(notification.title)\"")
            } catch Clang.ClangError.missingFieldError(let missingField) {
                print("Error creating Notification object: Missing field \(missingField)")
            } catch {
                print("Unexpected error: \(error).")
            }
        }
    }
    /// Firebase messaging delegate for receiving FCM token
    /// - Parameters:
    ///   - messaging: The messaging object from Firebase
    ///   - fcmToken: The FCM token we need to register our device with
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        if let unwrappedToken = fcmToken {
            print("AppDelegate+NotificationExtension: Received FCM Token: \(unwrappedToken)")
            // Check for a saved token here, when there is one we know that this device is already registered
            // we only need to update the token then. Else register this device for an account
            if let token = UserDefaults.standard.string(forKey: "FCMToken"), !token.isEmpty {
                print("AppDelegate+NotificationExtension: Found FirebaseToken in UserDefaults no need to re-register")

                self.updateFCMToken(fcmToken: unwrappedToken)
            } else {
                print("AppDelegate+NotificationExtension: No FirebaseToken found in UserDefaults going to register")
                Clang().registerAccount(fcmToken: unwrappedToken) { id, error in
                    guard error == nil else {
                        print("AppDelegate+NotificationExtension: \(error!)")
                        return
                    }
                    print("AppDelegate+NotificationExtension: USER IS \(id ?? "")")
                    UserDefaults.standard.set(fcmToken, forKey: "FCMToken")
                }
            }
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
    }
    
    /// Update the FCM token and re-register with Clang
    func updateFCMToken(fcmToken: String) {
        Clang().updateTokenOnServer(fcmToken: fcmToken) { error in
            guard error == nil else {
                print("AppDelegate+NotificationExtension: Error updating token on server")
                return
            }
            
            print("AppDelegate+NotificationExtension: Updating token on server successfull")
            UserDefaults.standard.set(fcmToken, forKey: "FCMToken")
        }
    }
    
    func getFirebaseToken() -> String? {
        Messaging.messaging().fcmToken
    }
}
