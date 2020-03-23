//
//  Environment.swift
//  ClangNotifications
//
//  Created by Tetiana Padalko on 20/01/2020.
//  Copyright © 2020 Worth Internet Systems. All rights reserved.
//

import Foundation

/// Contains Key/Values to get all the information we need from the info.plist
public enum Environment {

  // MARK: - Keys

  /// The Info.plist keys we want to retrieve data from
  enum PlistKeys {
    /// The base url of the API calls
    static let baseURL = "BASE_URL"
    /// The token we use in the authorization header of the APi calls
    static let authorizationToken = "AUTHORIZATION_TOKEN"
    /// The id we use in the body of the API calls
    static let integrationId = "INTEGRATION_ID"
  }

  // MARK: - Plist

  /// Get the info dictioanry of the integrator app. If none is found this code will crash
  private static let infoDictionary: [String: Any] = {
    guard let dict = Bundle.main.infoDictionary else {
      fatalError("Plist file not found")
    }
    return dict
  }()

  // MARK: - Plist values

  /// Get the root url from the info.plist found in the integrator's app. If there is no root url set this code will crash
  static let baseURL: URL = {
    guard let baseUrl = Environment.infoDictionary[PlistKeys.baseURL] as? String else {
      fatalError("Base URL not found in info.plist")
    }

    guard let url = URL(string: baseUrl) else {
      fatalError("Root URL is invalid")
    }
    return url
  }()

  /// Get the authorization token from the info.plist found in the integrator's app. If there is no Authorization token set this code will crash
  static let authorizationToken: String = {
    guard let authToken = Environment.infoDictionary[PlistKeys.authorizationToken] as? String else {
      fatalError("Authorization token was not set in info.plist")
    }

    return authToken
  }()

  /// Get the integration id from the info.plist found in the integrato's app. If there is no integration id set this code will crash
  static let integrationId: String = {
    guard let integrationId = Environment.infoDictionary[PlistKeys.integrationId] as? String else {
      fatalError("Integration ID was not set in info.plist")
    }

    return integrationId
  }()
}
