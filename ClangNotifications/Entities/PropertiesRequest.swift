//
//  PropertiesRequest.swift
//  ClangNotifications
//
//  Created by Sebastiaan Seegers on 17/03/2020.
//  Copyright © 2020 Worth Internet Systems. All rights reserved.
//

import Foundation

struct PropertiesRequest: Codable {
  var userId: String
  var data: [String: String]
}
