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

  /// The user id
  var userId: String

  /// The Firebase tokens we want to send
  var tokens: [String]

  /// The integration id
  var integrationId: String

  /// Customized Init so we don't need to pass the integration id which is defined in Environment
  /// - Parameters:
  ///   - userId: The user id
  ///   - token: The Firebase token we want to save on the Clang backend
  init(userId: String, token: String) {
    self.userId = userId
    self.tokens = [token]
    self.integrationId = Environment.integrationId
  }
}
