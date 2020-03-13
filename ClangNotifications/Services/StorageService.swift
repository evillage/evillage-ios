//
//  StorageService.swift
//  ClangNotifications
//
//  Created by Tetiana Padalko on 05/11/2019.
//  Copyright © 2019 Worth Internet Systems. All rights reserved.
//

import Foundation
import UIKit

protocol StorageServiceProtocol: class {
  func saveUserId(userId: String)
  func saveUserSecret(secret: String)
  func loadUserId() -> String?
  func loadUserSecret() -> String?
  func getDeviceId() -> String?
}

class StorageService: StorageServiceProtocol {

  private let logTag = "\(StorageService.self)"

  /// Save the userId  in keychain
  /// - Parameter userId: The userId of the current registered user
  func saveUserId(userId: String) {
    let data = Data(from: userId)
    let status = KeyChainService.save(key: "clang_user_id", data: data)
    print("\(logTag): status: \(status)")
  }

  /// Save the user secret in the keychain
  /// - Parameter secret: The secret we want to save in the keychain
  func saveUserSecret(secret: String) {
    let data = Data(from: secret)
    let status = KeyChainService.save(key: "clang_user_secret", data: data)
    print("\(logTag): status: \(status)")
  }

  /// Load the userId from the keychain
  /// - Returns: Return the userId as an optional String
  func loadUserId() -> String? {
    guard let receivedData = KeyChainService.load(key: "clang_user_id") else { return nil }
    let result = receivedData.to(type: String.self)
    print("\(logTag): user id: \(result)")
    return result
  }

  /// Load the user secret from keychain
  /// - Returns: The user's secret as an optional String
  func loadUserSecret() -> String? {
    guard let receivedData = KeyChainService.load(key: "clang_user_secret") else { return nil }
    let result = receivedData.to(type: String.self)
    print("\(logTag): secret: \(result)")
    return result
  }

  /// Get the UUID of this device
  /// - Returns: An optional String containing this device's uuid
  func getDeviceId() -> String? {
    guard let uuid = UIDevice.current.identifierForVendor?.uuidString else { return nil }
    print("\(logTag): \(uuid)")
    return uuid
  }
}
