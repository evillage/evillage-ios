//
//  EventLogRequest.swift
//  ClangNotifications
//
//  Created by Tetiana Padalko on 06/11/2019.
//  Copyright © 2019 Worth Internet Systems. All rights reserved.
//

import Foundation

struct EventLogRequest: Codable {
  var userId: String
  var event: String
  var data: [String: String]
}
