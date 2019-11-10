//
//  LogActionInteractor.swift
//  ClangNotifications
//
//  Created by Tetiana Padalko on 06/11/2019.
//  Copyright © 2019 Worth Internet Systems. All rights reserved.
//

import Foundation

protocol LogActionInteractorProtocol: class {
    func logNotificationAction(notificationId: String, actionId: String, completion: @escaping (Error?) -> Swift.Void)
    func logEvent(event: String, data: [String: String], completion: @escaping (Error?) -> Swift.Void)
}

class LogActionInteractor: LogActionInteractorProtocol {
    
    let serverService: ServerServiceProtocol = ServerService()
    let storageService: StorageServiceProtocol = StorageService()
    
    func logNotificationAction(notificationId: String, actionId: String, completion: @escaping (Error?) -> Swift.Void) {
        
        let userId = storageService.loadUserId()

        let notificationRequest = NotificationActionRequest(notificationId: notificationId, userId: userId!, actionId: actionId)
        
        serverService.logNotificationAction(notificationAction: notificationRequest) { (error) in
            if error != nil {
                print(error!)
                completion(error)
                return
            } else {
                completion(nil)
                return
            }
        }
    }
    
    
    func logEvent(event: String, data: [String: String], completion: @escaping (Error?) -> Swift.Void) {
        
//        let userId = storageService.loadUserId()
        let userId = "iOS"
        
        let eventRequest = EventLogRequest(userId: userId, event: event, data: data)
        
        serverService.logEvent(eventLog: eventRequest) { (error) in
            if error != nil {
                print(error!)
                completion(error)
                return
            } else {
                completion(nil)
                return
            }
        }
    }
}
