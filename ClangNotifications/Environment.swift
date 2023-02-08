//
//  Environment.swift
//  ClangNotifications
//
//  Created by Tetiana Padalko on 20/01/2020.
//  Copyright © 2020 Worth Internet Systems. All rights reserved.
//

import Foundation

/// Contains Key/Values to get all the information we need from the info.plist
public enum Environment {

    // MARK: - values

    /// Ready  set url
    static let baseURL: URL = URL(string: "https://api.clang.cloud")!
    /// Public authorizationToken provided.  If there is no Authorization token set this code will crash
    public static var authorizationToken: String = ""
    /// Public integrationId provided. If there is no integration id set this code will crash
    public static var integrationId: String = ""

}
