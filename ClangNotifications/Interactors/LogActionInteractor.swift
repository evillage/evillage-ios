//
//  LogActionInteractor.swift
//  ClangNotifications
//
//  Created by Tetiana Padalko on 06/11/2019.
//  Copyright © 2019 Worth Internet Systems. All rights reserved.
//

import Foundation

protocol LogActionInteractorProtocol: class {
  func logNotificationAction(notificationId: String, actionId: String, completion: @escaping (Error?) -> Void)
  func logEvent(event: String, data: [String: String], completion: @escaping (Error?) -> Swift.Void)
}

class LogActionInteractor: LogActionInteractorProtocol {
  /// Tag to used in debug prints for easy search in Xcode debug console
  private let logTag = "\(LogActionInteractor.self)"

  private let serverService: ServerServiceProtocol = ServerService()
  private let storageService: StorageServiceProtocol = StorageService()

  func logNotificationAction(notificationId: String, actionId: String, completion: @escaping (Error?) -> Void) {
    let userId = storageService.loadUserId()
    let notificationRequest = NotificationActionRequest(notificationId: notificationId, userId: userId!, actionId: actionId)

    serverService.logNotificationAction(notificationAction: notificationRequest) { error in
      guard error == nil else {
        print("\(LogActionInteractor.self): \(error!)")
        completion(error)
        return
      }
      completion(nil)
      return
    }
  }

  func logEvent(event: String, data: [String: String], completion: @escaping (Error?) -> Void) {
    guard let userId = storageService.loadUserId() else {
      completion(APIError.parseError)
      return
    }
    let eventRequest = EventLogRequest(userId: userId, event: event, data: data)
    serverService.logEvent(eventLog: eventRequest) { error in
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
