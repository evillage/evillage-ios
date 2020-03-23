//
//  EventLogRequest.swift
//  ClangNotifications
//
//  Created by Tetiana Padalko on 06/11/2019.
//  Copyright © 2019 Worth Internet Systems. All rights reserved.
//

import Foundation

/// Simple struct to encode the event log request data needed for the API call to JSON
struct EventLogRequest: Codable {
  /// The user id
  var userId: String

  /// The name of the event we want to log
  var event: String

  /// The data we want to send with the event
  var data: [String: String]

  /// The integration id
  var integrationId: String

  /// Customized Init so we don't need to pass the integration id which is defined in Environment
  /// - Parameters:
  ///   - userId: The user id
  ///   - event: The event name
  ///   - data: The event data
  init(userId: String, event: String, data: [String: String]) {
    self.userId = userId
    self.event = event
    self.data = data
    self.integrationId = Environment.integrationId
  }
}
