//
//  SaveTokenRequest.swift
//  ClangNotifications
//
//  Created by Tetiana Padalko on 06/11/2019.
//  Copyright © 2019 Worth Internet Systems. All rights reserved.
//

import Foundation

/// Simple struct to encode the save token request data needed for the API call to JSON
struct SaveTokenRequest: Codable {

  /// Unique device id
  var id: String

  /// The Firebase tokens we want to send
  var token: String

  /// The integration id
  var integrationId: String

  /// Customized Init so we don't need to pass the integration id which is defined in Environment
  /// - Parameters:
  ///   - id: The unique deviec id
  ///   - token: The Firebase token we want to save on the Clang backend
  init(id: String, token: String) {
    self.id = id
    self.token = token
    self.integrationId = Environment.integrationId
  }
}
