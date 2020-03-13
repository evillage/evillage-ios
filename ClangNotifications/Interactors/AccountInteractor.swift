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
  let serverService: ServerServiceProtocol = ServerService()
  let storageService: StorageServiceProtocol = StorageService()

  func registerAccount(firebaseToken: String, completion: @escaping (String?, Error?) -> Void) {
    guard let deviceId = storageService.getDeviceId() else { return  }
    let registerAccountModel = RegisterAccountRequest(deviceId: deviceId, token: firebaseToken, customerId: Environment.customerId)

    serverService.registerAccount(registerAccount: registerAccountModel) { registerAccountResponse, error in
      guard error == nil else {
        print(error!)
        completion(nil, error)
        return
      }
      self.storageService.saveUserId(userId: registerAccountResponse?.id ?? "")
      self.storageService.saveUserSecret(secret: registerAccountResponse?.secret ?? "") // User secret to be removed
      completion(registerAccountResponse?.id, nil)
      return
    }
  }
}
