//
//  Environment.swift
//  ClangNotifications
//
//  Created by Tetiana Padalko on 20/01/2020.
//  Copyright © 2020 Worth Internet Systems. All rights reserved.
//

import Foundation

public enum Environment {

  // MARK: - Keys

  enum PlistKeys {
    static let authorizationToken = "AUTHORIZATION_TOKEN"
    static let integrationId = "INTEGRATION_ID"
  }

  // MARK: - Plist

  private static let infoDictionary: [String: Any] = {
    guard let dict = Bundle.main.infoDictionary else {
      fatalError("Plist file not found")
    }
    return dict
  }()

  // MARK: - Plist values

  /// Get the root url from the info.plist found in the integrator's app. If there is no root url set the app will crash
  static let baseURL: URL = {
    guard let url = URL(string: "https://c4ac1473.ngrok.io") else {
      fatalError("Root URL is invalid")
    }
    return url
  }()

  /// Get the authorization token from the info.plist found in the integrator's app. If there is no Authorization token set the app will crash
  static let authorizationToken: String = {
    guard let authToken = Environment.infoDictionary[PlistKeys.authorizationToken] as? String else {
      fatalError("Authorization token was not set in Plist")
    }

    return authToken
  }()

  static let integrationId: String = {
    guard let integrationId = Environment.infoDictionary[PlistKeys.integrationId] as? String else {
      fatalError("Integration ID was not set in Plist")
    }

    return integrationId
  }()
}
