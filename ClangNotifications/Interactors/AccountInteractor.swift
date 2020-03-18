//
//  AccountInteractor.swift
//  ClangNotifications
//
//  Created by Tetiana Padalko on 06/11/2019.
//  Copyright © 2019 Worth Internet Systems. All rights reserved.
//

import Foundation

protocol AccountInteractorProtocol: class {
  func registerAccount(firebaseToken: String, completion: @escaping (String?, Error?) -> Void)
}

class AccountInteractor: AccountInteractorProtocol {
  /// Tag to used in debug prints for easy search in Xcode debug console
  private let logTag = "\(AccountInteractor.self)"

  let serverService: ServerServiceProtocol = ServerService()
  let storageService: StorageServiceProtocol = StorageService()

  func registerAccount(firebaseToken: String, completion: @escaping (String?, Error?) -> Void) {
    guard let deviceId = storageService.getDeviceId() else { return  }
    let registerAccountModel = RegisterAccountRequest(deviceId: deviceId, token: firebaseToken)

    serverService.registerAccount(registerAccount: registerAccountModel) { registerAccountResponse, error in
      guard error == nil else {
        print("\(self.logTag): \(error!)")
        completion(nil, error)
        return
      }

      self.storageService.saveUserId(userId: registerAccountResponse?.id ?? "")
      completion(registerAccountResponse?.id, nil)
    }
  }
}
