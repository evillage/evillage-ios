//
//  NotificationActionRequest.swift
//  ClangNotifications
//
//  Created by Tetiana Padalko on 06/11/2019.
//  Copyright © 2019 Worth Internet Systems. All rights reserved.
//

import Foundation

/// Simple struct to encode the notification action request data needed for the API call to JSON
struct NotificationActionRequest: Codable {

  /// The notification id
  var notificationId: String

  /// The user id
  var userId: String

  /// The action id
  var actionId: String

  /// The event name
  var event: String

  /// The integration id
  var integrationId: String

  /// Customized Init so we don't need to pass the integration id which is defined in Environment
  /// - Parameters:
  ///   - notificationId: The notification id description
  ///   - userId: The user id
  ///   - actionId: The action id description
  init(notificationId: String, userId: String, actionId: String) {
    self.notificationId = notificationId
    self.userId = userId
    self.actionId = actionId
    self.event = "Notification"
    self.integrationId = Environment.integrationId
  }
}
