//
//  SaveTokenRequest.swift
//  ClangNotifications
//
//  Created by Tetiana Padalko on 06/11/2019.
//  Copyright © 2019 Worth Internet Systems. All rights reserved.
//

import Foundation

class SaveTokenRequest: Codable {
    var userId: String
    var tokens: Array<String>
    
    init(userId: String, token: String) {
      self.userId = userId
        self.tokens = [token]
    }
}
