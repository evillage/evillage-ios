//
//  RegisterAccountResponse.swift
//  ClangNotifications
//
//  Created by Tetiana Padalko on 05/11/2019.
//  Copyright © 2019 Worth Internet Systems. All rights reserved.
//

import Foundation

/// Simple struct to easily decode the register account response JSON to a usable format
struct RegisterAccountResponse: Codable {

  /// The user id we get from the backend as a response to the Register api call
  var id: String
}
