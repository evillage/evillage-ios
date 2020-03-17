//
//  Clang.swift
//  ClangNotifications
//
//  Created by Tetiana Padalko on 05/11/2019.
//  Copyright © 2019 Worth Internet Systems. All rights reserved.
//

import Foundation

public class Clang {
  private let accountInteractor: AccountInteractorProtocol = AccountInteractor()
  private let logActionInteractor: LogActionInteractorProtocol = LogActionInteractor()
  private let tokenInteractor: TokenInteractorProtocol = TokenInteractor()
  private let propertiesInteractor: PropertiesInteractorProtocol = PropertiesInteractor()

  public init() { }

  public func registerAccount(firebaseToken: String, completion: @escaping (String?, Error?) -> Void) {
    accountInteractor.registerAccount(firebaseToken: firebaseToken, completion: completion)
  }

  public func logEvent(event: String, data: [String: String], completion: @escaping (Error?) -> Void) {
    logActionInteractor.logEvent(event: event, data: data, completion: completion)

  }

  public func logNotification(notificationId: String, actionId: String, completion: @escaping (Error?) -> Void) {
    logActionInteractor.logNotificationAction(notificationId: notificationId, actionId: actionId, completion: completion)
  }

  public func updateTokenOnServer(firebaseToken: String, completion: @escaping (Error?) -> Void) {
    tokenInteractor.sendTokenToServer(firebaseToken: firebaseToken, completion: completion)
  }

  public func updateProperties(data: [String: String], completion: @escaping (Error?) -> Void) {
    propertiesInteractor.updateProperties(data: data, completion: completion)
  }
}
