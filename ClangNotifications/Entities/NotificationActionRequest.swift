//
//  NotificationActionRequest.swift
//  ClangNotifications
//
//  Created by Tetiana Padalko on 06/11/2019.
//  Copyright © 2019 Worth Internet Systems. All rights reserved.
//

import Foundation

struct NotificationActionRequest: Codable {
  var notificationId: String
  var userId: String
  var actionId: String
  var event: String

  init(notificationId: String, userId: String, actionId: String) {
    self.notificationId = notificationId
    self.userId = userId
    self.actionId = actionId
    self.event = "Notification"
  }
}
