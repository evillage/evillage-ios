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
  enum Keys {
    enum Plist {
      static let rootURL = "ROOT_URL"
      static let customerId = "CUSTOMER_ID"
    }
  }

  // MARK: - Plist
  private static let infoDictionary: [String: Any] = {
    guard let dict = Bundle.main.infoDictionary else {
      fatalError("Plist file not found")
    }
    return dict
  }()

  // MARK: - Plist values
  static let rootURL: URL = {
    guard let rootURLstring = Environment.infoDictionary[Keys.Plist.rootURL] as? String else {
      fatalError("Root URL not set in plist for this environment")
    }
    guard let url = URL(string: rootURLstring) else {
      fatalError("Root URL is invalid")
    }
    return url
  }()

  static let customerId: String = {
    guard let customerId = Environment.infoDictionary[Keys.Plist.customerId] as? String else {
      fatalError("Customer Id not set in plist for this environment")
    }
    return customerId
  }()
}
