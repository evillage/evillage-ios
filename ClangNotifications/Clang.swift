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
    
    public init() {}
    
    public func registerAccount(firebaseToken: String, completion: @escaping (String?, Error?) -> Swift.Void) {
        accountInteractor.registerAccount(firebaseToken: firebaseToken, completion: completion)
    }
    
    public func logEvent(event: String, data: [String: String], completion: @escaping (Error?) -> Swift.Void) {
        logActionInteractor.logEvent(event: event, data: data, completion: completion)
        
    }
}
