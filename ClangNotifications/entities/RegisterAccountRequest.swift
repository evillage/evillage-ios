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
    
    init(deviceId: String, token: String) {
        self.deviceId = deviceId.description
        self.token = token
    }
}
