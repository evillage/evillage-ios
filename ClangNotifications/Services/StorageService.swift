//
//  StorageService.swift
//  ClangNotifications
//
//  Created by Tetiana Padalko on 05/11/2019.
//  Copyright © 2019 Worth Internet Systems. All rights reserved.
//

import Foundation
import UIKit

private enum Keychainids {
  static let userId = "clang_user_id"
}

protocol StorageServiceProtocol: class {
  func saveUserId(userId: String)
  func loadUserId() -> String?
  func getDeviceId() -> String?
}

class StorageService: StorageServiceProtocol {

  /// Tag to used in debug prints for easy search in Xcode debug console
  private let logTag = "\(StorageService.self)"

  /// Save the userId  in keychain
  /// - Parameter userId: The userId of the current registered user
  internal func saveUserId(userId: String) {
    guard let data = userId.data(using: .utf8) else { fatalError("Error creating UserID data") }
    let status = KeyChainService.save(key: Keychainids.userId, data: data)
    print("\(logTag): status: \(status)")
  }

  /// Load the userId from the keychain
  /// - Returns: Return the userId as an optional String
  internal func loadUserId() -> String? {
    guard let receivedData = KeyChainService.load(key: Keychainids.userId),
      let result = String(data: receivedData, encoding: .utf8) else {
        return nil
    }
    print("\(logTag): user id: \(result)")
    return result
  }

  /// Get the UUID of this device
  /// - Returns: An optional String containing this device's uuid
  internal func getDeviceId() -> String? {
    guard let deviceId = UIDevice.current.identifierForVendor?.uuidString else {
      print("\(self.logTag): IdentifierForVendor returned nil!")
      return nil
    }
    print("\(logTag): UDID: \(deviceId)")
    return deviceId
  }
}
