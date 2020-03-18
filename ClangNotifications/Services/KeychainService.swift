//
//  KeychainService.swift
//  ClangNotifications
//
//  Created by Tetiana Padalko on 05/11/2019.
//  Copyright © 2019 Worth Internet Systems. All rights reserved.
//

import Foundation

class KeyChainService {

  /// Save data in the keychain
  /// - Parameters:
  ///   - key: The key of the data we want to save so we can find it back in the keychain
  ///   - data: The data we want to save in the keychain
  /// - Returns: A OSStatus object containing keychain result codes
  class func save(key: String, data: Data) -> OSStatus {
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword as String,
      kSecAttrAccount as String: key,
      kSecValueData as String: data]

    SecItemDelete(query as CFDictionary)
    return SecItemAdd(query as CFDictionary, nil)
  }

  /// Load data from the keychain with a given key
  /// - Parameter key: The given key of which we want to load the data from
  /// - Returns: An optional Data object containing the requested data from the keychain
  class func load(key: String) -> Data? {
    let query: [String: Any] = [
      kSecClass as String: kSecClassGenericPassword,
      kSecAttrAccount as String: key,
      kSecReturnData as String: true,
      kSecMatchLimit as String: kSecMatchLimitOne]

    var dataTypeRef: AnyObject?
    guard SecItemCopyMatching(query as CFDictionary, &dataTypeRef) == noErr else { return nil }
    return dataTypeRef as? Data
  }
}
