//
//  DataExtension.swift
//  ClangNotifications
//
//  Created by Sebastiaan Seegers on 13/03/2020.
//  Copyright © 2020 Worth Internet Systems. All rights reserved.
//

import Foundation

extension Data {
  init<T>(from value: T) {
    var value = value
    self.init(buffer: UnsafeBufferPointer(start: &value, count: 1))
  }

  func to<T>(type: T.Type) -> T {
    return self.withUnsafeBytes { $0.load(as: T.self) }
  }
}
