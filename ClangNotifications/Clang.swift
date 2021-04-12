//
//  Clang.swift
//  ClangNotifications
//
//  Created by Tetiana Padalko on 05/11/2019.
//  Copyright © 2019 Worth Internet Systems. All rights reserved.
//

import Foundation

/// Contains all the methods needed for integrating the Clang backend in your app
public class Clang {
    public enum ClangError: Error {
        case missingFieldError(field: String)
    }

    public struct ClangNotification {
        public var id: String
        public var category: String
        public var type: String
        public var title: String
        public var message: String
        public var actions: [String: String]
        public var customFields: [String: String]

        init(userInfo: [AnyHashable: Any]) throws {
            actions = [:]
            customFields = [:]

            // Get required fields from userInfo struct
            guard let notificationId: String = userInfo[AnyHashable("notificationId")] as? String else {
                throw ClangError.missingFieldError(field: "notificationId")
            }
            self.id = notificationId

            guard let notificationCategory: String = userInfo[AnyHashable("notificationCategory")] as? String else {
                throw ClangError.missingFieldError(field: "notificationCategory")
            }
            self.category = notificationCategory

            guard let type: String = userInfo[AnyHashable("type")] as? String else {
                throw ClangError.missingFieldError(field: "type")
            }
            self.type = type

            guard let notificationTitle: String = userInfo[AnyHashable("notificationTitle")] as? String else {
                throw ClangError.missingFieldError(field: "notificationTitle")
            }
            self.title = notificationTitle

            guard let notificationBody: String = userInfo[AnyHashable("notificationBody")] as? String else {
                throw ClangError.missingFieldError(field: "notificationBody")
            }
            self.message = notificationBody

            // Handle actions and custom fields
            for (key, val) in userInfo {
                let keyString = key as? String ?? ""
                let valString = val as? String ?? ""

                if keyString.starts(with: "action1") {
                    guard let action1Id: String = userInfo[AnyHashable("action1Id")] as? String else {
                        throw ClangError.missingFieldError(field: "action1Id")
                    }
                    guard let action1Title: String = userInfo[AnyHashable("action1Title")] as? String else {
                        throw ClangError.missingFieldError(field: "action1Title")
                    }
                    self.actions.updateValue(action1Title, forKey: action1Id)
                }

                if keyString.starts(with: "action2") {
                    guard let action2Id: String = userInfo[AnyHashable("action2Id")] as? String else {
                        throw ClangError.missingFieldError(field: "action2Id")
                    }
                    guard let action2Title: String = userInfo[AnyHashable("action2Title")] as? String else {
                        throw ClangError.missingFieldError(field: "action2Title")
                    }
                    self.actions.updateValue(action2Title, forKey: action2Id)
                }

                if keyString.starts(with: "action3") {
                    guard let action3Id: String = userInfo[AnyHashable("action3Id")] as? String else {
                        throw ClangError.missingFieldError(field: "action3Id")
                    }
                    guard let action3Title: String = userInfo[AnyHashable("action3Title")] as? String else {
                        throw ClangError.missingFieldError(field: "action3Title")
                    }
                    self.actions.updateValue(action3Title, forKey: action3Id)
                }

                if keyString.starts(with: "custom_") {
                    let customFieldName = keyString.replacingOccurrences(of: "custom_", with: "")
                    self.customFields.updateValue(valString, forKey: customFieldName)
                }
            }
            print(self)
        }
    }


    /// The AccountInteractor reference
    private let accountInteractor: AccountInteractorProtocol = AccountInteractor()

    /// The LogActionInteractor reference
    private let logActionInteractor: LogActionInteractorProtocol = LogActionInteractor()

    /// The TokenInteractor reference
    private let tokenInteractor: TokenInteractorProtocol = TokenInteractor()

    /// The PropertiesInteractorReference
    private let propertiesInteractor: PropertiesInteractorProtocol = PropertiesInteractor()

    /// The required initifalizer for the Clang library
    public init() { }

    /// Register for an account with the Clang backend and make sure that you can receive push notifications
    /// - Parameters:
    ///   - fcmToken: The token we receive from Firebase when registering for push notifications
    ///   - completion: The callback after registering for an account
    ///   - userId: Optional user id String we got when registering. This value be filled when error is nil
    ///   - error: Optional Error object,  If Error is nil then registering was successfull
    public func registerAccount(fcmToken: String, completion: @escaping (_ userId: String?, _ error: Error?) -> Void) {
        accountInteractor.registerAccount(fcmToken: fcmToken, completion: completion)
    }

    /// Log an event to the Clang backend
    /// - Parameters:
    ///   - eventName: The name of the event you want to log
    ///   - data: The data you want to log for this event
    ///   - completion: The callback after logging the event
    ///   - error: Optional Error object, If Error is nil then logging the event was successfull
    public func logEvent(eventName: String, eventData: [String: String], completion: @escaping (_ error: Error?) -> Void) {
        logActionInteractor.logEvent(event: eventName, data: eventData, completion: completion)
    }

    /// Log a notification to the Clang backend
    /// - Parameters:
    ///   - notificationId: The id of the notification
    ///   - actionId: The id of the notification action the user chose
    ///   - completion: The callback after logging the notification
    ///   - error: Optional Error object, if Error is nil then logging the notification was successfull
    public func logNotification(notificationId: String, actionId: String, completion: @escaping (_ error: Error?) -> Void) {
        logActionInteractor.logNotificationAction(notificationId: notificationId, actionId: actionId, completion: completion)
    }

    /// Update the Firebase Token on the server. This is usually called when the Firebase token changed
    /// - Parameters:
    ///   - fcmToken: The token we receive from Firebase when registering for push notifications
    ///   - completion: The callback after updating the token
    ///   - error: Optional Error object, if the Error is nil then updating the token on the server was successfull
    public func updateTokenOnServer(fcmToken: String, completion: @escaping (_ error: Error?) -> Void) {
        tokenInteractor.sendTokenToServer(firebaseToken: fcmToken, completion: completion)
    }

    /// Update properties on the Clang backend
    /// - Parameters:
    ///   - data: The property data we want to update
    ///   - completion: Contains an optional Error object. if error is nil then updating the properties was successfull
    ///   - error: Optional Error object, if the Error is nil then updating the properties on the server was successfull
    public func updateProperties(data: [String: String], completion: @escaping (_ error: Error?) -> Void) {
        propertiesInteractor.updateProperties(data: data, completion: completion)
    }

    public func isClangNotification(userInfo: [AnyHashable: Any]) -> Bool {
        guard let type: String = userInfo[AnyHashable("type")] as? String else {
            return false
        }
        return type == "clang"
    }

    public func createNotification(userInfo: [AnyHashable: Any]) throws -> Clang.ClangNotification {
        return try ClangNotification(userInfo: userInfo)
    }
}
