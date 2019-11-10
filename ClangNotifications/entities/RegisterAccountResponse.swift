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
    
    init(id: String) {
      self.id = id
    }
}
