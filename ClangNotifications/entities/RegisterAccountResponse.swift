//
//  RegisterAccountResponse.swift
//  ClangNotifications
//
//  Created by Tetiana Padalko on 05/11/2019.
//  Copyright © 2019 Worth Internet Systems. All rights reserved.
//

import Foundation

class RegisterAccountResponse: Codable {
    var id: String
    var secret: String
    
    init(id: String, secret: String) {
      self.id = id
      self.secret = secret
    }
}
