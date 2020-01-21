//
//  RegisterAccountRequest.swift
//  ClangNotifications
//
//  Created by Tetiana Padalko on 05/11/2019.
//  Copyright © 2019 Worth Internet Systems. All rights reserved.
//

import Foundation

class RegisterAccountRequest: Codable {
    var deviceId: String
    var token: String
    var customerId: String
    
    init(deviceId: String, token: String, customerId: String) {
        self.deviceId = deviceId.description
        self.token = token
        self.customerId = customerId
    }
}
