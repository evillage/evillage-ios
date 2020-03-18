//
//  PropertiesInteractor.swift
//  ClangNotifications
//
//  Created by Sebastiaan Seegers on 17/03/2020.
//  Copyright © 2020 Worth Internet Systems. All rights reserved.
//

import Foundation

protocol PropertiesInteractorProtocol: class {
  func updateProperties(data: [String: String], completion: @escaping (Error?) -> Void)
}

class PropertiesInteractor: PropertiesInteractorProtocol {
  /// Tag to used in debug prints for easy search in Xcode debug console
  private let logTag = "\(PropertiesInteractor.self)"

  let serverService: ServerServiceProtocol = ServerService()
  let storageService: StorageServiceProtocol = StorageService()

  func updateProperties(data: [String: String], completion: @escaping (Error?) -> Void) {
    guard let userId = storageService.loadUserId() else {
      print("\(self.logTag): UserId is nil!")
      return
    }

    let propertiesRequestModel = PropertiesRequest(userId: userId, data: data)
    serverService.updateProperties(propertiesRequest: propertiesRequestModel) { error in
      guard error == nil else {
        print("\(self.logTag): \(error!)")
        return
      }

      completion(nil)
    }
  }
}
