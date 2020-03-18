//
//  EventLogRequest.swift
//  ClangNotifications
//
//  Created by Tetiana Padalko on 06/11/2019.
//  Copyright © 2019 Worth Internet Systems. All rights reserved.
//

import Foundation

struct EventLogRequest: Codable {
  var userId: String
  var event: String
  var data: [String: String]
  var integrationId: String

  init(userId: String, event: String, data: [String: String]) {
    self.userId = userId
    self.event = event
    self.data = data
    self.integrationId = Environment.integrationId
  }
}
