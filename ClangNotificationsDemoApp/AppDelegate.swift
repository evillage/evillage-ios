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
class AppDelegate: UIResponder, UIApplicationDelegate, MessagingDelegate, UNUserNotificationCenterDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        registerForPushNotifications(application)
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
          Messaging.messaging().apnsToken = deviceToken
    }

    
    
        public func registerForPushNotifications(_ application: UIApplication) {
            Messaging.messaging().delegate = self
            Messaging.messaging().shouldEstablishDirectChannel = true
            
            if #available(iOS 10.0, *) {
                // For iOS 10 display notification (sent via APNS)
                UNUserNotificationCenter.current().delegate = self
                let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
                
                UNUserNotificationCenter.current().requestAuthorization(
                    options: authOptions,
                    completionHandler: {_, _ in })
                
                let  likeAction = UNNotificationAction(identifier: "like_action", title: "Like",
                options: UNNotificationActionOptions(rawValue: 0))
                let  dislikeAction = UNNotificationAction(identifier: "dislike_action", title: "Dislike",
                options: UNNotificationActionOptions(rawValue: 0))
                let  dismissAction = UNNotificationAction(identifier: "dismiss_action", title: "Dismiss",
                options: UNNotificationActionOptions(rawValue: 0))

                let clangCategory = UNNotificationCategory(identifier: "clang", actions: [likeAction, dislikeAction, dismissAction], intentIdentifiers: [])
                
                UNUserNotificationCenter.current().setNotificationCategories([clangCategory])
                
                // For iOS 10 data message (sent via FCM)
            } else {
                let settings: UIUserNotificationSettings =
                    UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
                application.registerUserNotificationSettings(settings)
            }
            application.registerForRemoteNotifications()
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
            InstanceID.instanceID().instanceID { (result, error) in
                if let result = result {
                    Clang().registerAccount(firebaseToken: result.token) { (userId, error) in
                        if error != nil {
                            print(error!)
                            return
                        } else {
                            print("USER IS: ", userId!)
                            return
                        }
                    }
                    
                    
//                    Clang().updateTokenOnServer(firebaseToken: result.token) { (error) in
//                        if error != nil {
//                            print(error!)
//                            return
//                        } else {
//                            print("SUCCESSFULLY UPDATED TOKEN!")
//                            return
//                        }
//                    }
                }
            }
    }
        func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
            print("Did receive: ", response)
            
            Clang().logNotification(notificationId: "EVillageDemo", actionId: response.actionIdentifier) { (error) in
                if error != nil {
                    print("PANIC: ", error!)
                    return
                } else {
                    print("SUCCESSFULLY LOGGED NOTIFICSTION!")
                    return
                }
            }
            completionHandler()
        }

}

