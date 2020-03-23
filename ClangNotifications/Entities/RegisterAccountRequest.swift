//
//  RegisterAccountRequest.swift
//  ClangNotifications
//
//  Created by Tetiana Padalko on 05/11/2019.
//  Copyright © 2019 Worth Internet Systems. All rights reserved.
//

import Foundation

/// Simple struct to encode the register account request data needed for the API call to JSON
struct RegisterAccountRequest: Codable {
  /// The device id
  var deviceId: String

  /// The Firebase token
  var token: String

  /// The integration id
  var integrationId: String

  /// Customized Init so we don't need to pass the integration id which is defined in Environment
  /// - Parameters:
  ///   - deviceId: The device id
  ///   - token: The Firebase token
  init(deviceId: String, token: String) {
    self.deviceId = deviceId
    self.token = token
    self.integrationId = Environment.integrationId
  }
}
