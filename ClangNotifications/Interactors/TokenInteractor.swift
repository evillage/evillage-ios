//
//  TokenInteractor.swift
//  ClangNotifications
//
//  Created by Tetiana Padalko on 06/11/2019.
//  Copyright © 2019 Worth Internet Systems. All rights reserved.
//

import Foundation

protocol TokenInteractorProtocol: class {
  func sendTokenToServer(firebaseToken: String, completion: @escaping (Error?) -> Void)
}

/// Tag to used in debug prints for easy search in Xcode debug console
private let logTag = "\(TokenInteractor.self)"

class TokenInteractor: TokenInteractorProtocol {
  let serverService: ServerServiceProtocol = ServerService()
  let storageService: StorageServiceProtocol = StorageService()

  func sendTokenToServer(firebaseToken: String, completion: @escaping (Error?) -> Void) {
    guard let userId = storageService.loadUserId() else {
      print("\(logTag): UserId is nil!")
      return
    }

    let tokenRequest = SaveTokenRequest(userId: userId, token: firebaseToken)
    serverService.saveToken(saveToken: tokenRequest) { error in
      guard error == nil else {
        print("\(logTag): \(error!)")
        completion(error)
        return
      }
      completion(nil)
      return
    }
  }
}
