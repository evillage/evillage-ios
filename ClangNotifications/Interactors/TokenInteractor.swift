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

class TokenInteractor: TokenInteractorProtocol {
  /// Tag to used in debug prints for easy search in Xcode debug console
  private let logTag = "\(TokenInteractor.self)"

  private let serverService: ServerServiceProtocol = ServerService()
  private let storageService: StorageServiceProtocol = StorageService()

  func sendTokenToServer(firebaseToken: String, completion: @escaping (Error?) -> Void) {
    guard let userId = storageService.loadUserId() else {
      print("\(self.logTag): UserId is nil!")
      return
    }

    let tokenRequest = SaveTokenRequest(id: userId, token: firebaseToken)
    serverService.saveToken(saveToken: tokenRequest) { error in
      guard error == nil else {
        print("\(self.logTag): \(error!)")
        completion(error)
        return
      }
      completion(nil)
      return
    }
  }
}
