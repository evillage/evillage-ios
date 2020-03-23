//
//  PropertiesRequest.swift
//  ClangNotifications
//
//  Created by Sebastiaan Seegers on 17/03/2020.
//  Copyright © 2020 Worth Internet Systems. All rights reserved.
//

import Foundation

/// Simple struct to encode the properties request data needed for the API call to JSON
struct PropertiesRequest: Codable {

  /// The user id
  var userId: String

  /// The data we want to save
  var data: [String: String]

  /// The integration id
  var integrationId: String

  /// Simple struct to encode the notification action request data needed for the API call to JSON
  /// - Parameters:
  ///   - userId: The user id
  ///   - data: The data we want to save
  init(userId: String, data: [String: String]) {
    self.userId = userId
    self.data = data
    self.integrationId = Environment.integrationId
  }
}
