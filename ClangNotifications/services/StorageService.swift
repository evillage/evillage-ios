//
//  StorageService.swift
//  ClangNotifications
//
//  Created by Tetiana Padalko on 05/11/2019.
//  Copyright © 2019 Worth Internet Systems. All rights reserved.
//

import Foundation
import UIKit

protocol StorageServiceProtocol: class {
    func saveUserId(userId: String)
    func loadUserId() -> String?
    func getDeviceId() -> String?
}

class StorageService: StorageServiceProtocol {
    
    func saveUserId(userId: String) {
       let data = Data(from: userId)
       let status = KeyChainService.save(key: "clang_user_id", data: data)
       print("status: ", status)
    }
    
    func loadUserId() -> String? {
//      if let receivedData = KeyChainService.load(key: "clang_user_id") {
//          let result = receivedData.to(type: String.self)
//          print("result: ", result)
//          return result
//      }
        return "5877f788-e8b8-4d41-ab4e-8872696772f4"
    }
    
    func getDeviceId() -> String? {
        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
            print(uuid)
            return uuid
        }
        return nil
    }
}
