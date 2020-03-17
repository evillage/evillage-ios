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
    static let rootURL = "ROOT_URL"
    static let customerId = "CUSTOMER_ID"
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
  static let rootURL: URL = {
    guard let rootURLstring = Environment.infoDictionary[PlistKeys.rootURL] as? String else {
      fatalError("Root URL not set in plist for this environment")
    }
    guard let url = URL(string: rootURLstring) else {
      fatalError("Root URL is invalid")
    }
    return url
  }()

  /// Get the customer id from the info.plist found in the integrator's app. If there is no Customer id set the app will crash
  static let customerId: String = {
    guard let customerId = Environment.infoDictionary[PlistKeys.customerId] as? String else {
      fatalError("Customer Id not set in plist for this environment")
    }

    return customerId
  }()

  /// Get the authorization token from the info.plist found in the integrator's app. If there is no Authorization token set the app will crash
  static let authorizationToken: String = {
    guard let authToken = Environment.infoDictionary[PlistKeys.authorizationToken] as? String else {
      fatalError("Authorization token was not set in Plist")
    }

    return authToken
  }()

  /// Get the integration id from the info.plist found in the integrator's app. If there is no integration id set the app will crash
  static let integrationId: String = {
    guard let integrationId = Environment.infoDictionary[PlistKeys.integrationId] as? String else {
      fatalError("Integration ID was not set in Plist")
    }
    return integrationId
  }()
}
