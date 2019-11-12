//
//  Clang.swift
//  ClangNotifications
//
//  Created by Tetiana Padalko on 05/11/2019.
//  Copyright © 2019 Worth Internet Systems. All rights reserved.
//

import Foundation


//public protocol ClangProtocol: class {
//    func registerAccount(completion: @escaping (String?, Error?) -> Swift.Void)
//    func logEvent(event: String, data: [String: String], completion: @escaping (Error?) -> Swift.Void)
//}

public class Clang {

    let accountInteractor: AccountInteractorProtocol = AccountInteractor()
    let logActionInteractor: LogActionInteractorProtocol = LogActionInteractor()
    let tokenInteractor: TokenInteractorProtocol = TokenInteractor()
    
    public init() {}
    
    public func registerAccount(firebaseToken: String, completion: @escaping (String?, Error?) -> Swift.Void) {
        accountInteractor.registerAccount(firebaseToken: firebaseToken, completion: completion)
    }
    
    public func logEvent(event: String, data: [String: String], completion: @escaping (Error?) -> Swift.Void) {
        logActionInteractor.logEvent(event: event, data: data, completion: completion)
        
    }
    
    public func logNotification(notificationId: String, actionId: String, completion: @escaping (Error?) -> Swift.Void) {
        logActionInteractor.logNotificationAction(notificationId: notificationId, actionId: actionId, completion: completion)
    }
    
    public func updateTokenOnServer(firebaseToken: String, completion: @escaping (Error?) -> Swift.Void) {
        tokenInteractor.sendTokenToServer(firebaseToken: firebaseToken, completion: completion)
    }
}
