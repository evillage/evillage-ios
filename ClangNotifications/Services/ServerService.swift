//
//  ServerService.swift
//  ClangNotifications
//
//  Created by Tetiana Padalko on 05/11/2019.
//  Copyright © 2019 Worth Internet Systems. All rights reserved.
//

import Foundation
import UIKit

/// HTTPRequest methods used in the API calls
private enum HTTPRequestMethod {
  static let post = "POST"
  static let get = "GET"
}

/// APIErrors that coud be generated when performing API calls
enum APIError: Error {
  case noData
  case parseError
}

protocol ServerServiceProtocol: class {
  func registerAccount(registerAccount: RegisterAccountRequest, completion: @escaping (RegisterAccountResponse?, Error?) -> Void)
  func saveToken(saveToken: SaveTokenRequest, completion: @escaping (Error?) -> Void)
  func logNotificationAction(notificationAction: NotificationActionRequest, completion: @escaping (Error?) -> Void)
  func logEvent(eventLog: EventLogRequest, completion: @escaping (Error?) -> Void)
}

class ServerService: ServerServiceProtocol {
  private let storageService: StorageServiceProtocol = StorageService()

  /// Tag to used in debug prints for easy search in Xcode debug console
  private let logTag: String = "\(ServerService.self)"

  // MARK: - ServerServiceProtocol methods

  internal func logNotificationAction(notificationAction: NotificationActionRequest, completion: @escaping (Error?) -> Void) {
    guard let notificationLogURL = URL(string: "\(Environment.rootURL)/api/v1/notification/action") else {
      preconditionFailure("\(logTag): Error cannot create URL for logging notifications")
    }
    let secret = self.storageService.loadUserSecret()
    var notificationLogUrlRequest = URLRequest(url: notificationLogURL)
    notificationLogUrlRequest.httpMethod = HTTPRequestMethod.post
    notificationLogUrlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
    notificationLogUrlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
    notificationLogUrlRequest.setValue("Bearer \(secret ?? "")", forHTTPHeaderField: "authentication")

    do {
      let jsonData = try JSONEncoder().encode(notificationAction)
      notificationLogUrlRequest.httpBody = jsonData
    } catch let error {
      print("\(logTag): Error cannot create JSON from notificationLog model")
      completion(error)
      return
    }

    let task = URLSession.shared.dataTask(with: notificationLogUrlRequest) { _, response, error in
      guard error == nil else {
        print("\(self.logTag): Error calling POST on /notification/action")
        print(error!)
        completion(error)
        return
      }

      guard let response = response as? HTTPURLResponse else {
        print("\(self.logTag): Error failed response")
        completion(APIError.noData)
        return
      }

      if response.statusCode == 204 || response.statusCode == 200 {
        print("\(self.logTag): Succesfully posted /notification/action")
        completion(nil)
        return
      }

      print("\(self.logTag): Error parsing response from POST on /notification/action")
      completion(APIError.parseError)
      return
    }
    task.resume()
  }

  internal func logEvent(eventLog: EventLogRequest, completion: @escaping (Error?) -> Void) {
    guard let eventLogURL = URL(string: "\(Environment.rootURL)/api/v1/notification/event") else {
      preconditionFailure("\(logTag): Error cannot create URL for event logging")
    }

    var eventLogUrlRequest = URLRequest(url: eventLogURL)
    eventLogUrlRequest.httpMethod = HTTPRequestMethod.post
    eventLogUrlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
    eventLogUrlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
    eventLogUrlRequest.setValue("Bearer \(self.storageService.loadUserSecret() ?? "")", forHTTPHeaderField: "authentication")

    do {
      let jsonData = try JSONEncoder().encode(eventLog)
      eventLogUrlRequest.httpBody = jsonData
    } catch {
      print("\(logTag): Error cannot create JSON from eventLog model")
      completion(error)
      return
    }

    let task = URLSession.shared.dataTask(with: eventLogUrlRequest) { _, response, error in
      guard error == nil else {
        print("\(self.logTag): Error calling POST on /notification/event")
        print(error!)
        completion(error)
        return
      }
      guard let response = response as? HTTPURLResponse else {
        print("\(self.logTag): Error failed response")
        completion(APIError.noData)
        return
      }

      if response.statusCode == 200 {
        print("\(self.logTag): Successfully did POST on /notification/event")
        completion(nil)
        return
      }

      print("\(self.logTag): Error parsing response from POST on /notification/event")
      completion(APIError.parseError)
    }
    task.resume()
  }

  internal func saveToken(saveToken: SaveTokenRequest, completion: @escaping (Error?) -> Void) {
    guard let saveTokenURL = URL(string: "\(Environment.rootURL)/api/v1/token/save") else {
      preconditionFailure("Error cannot create URL for saving token")
    }

    var saveTokenUrlRequest = URLRequest(url: saveTokenURL)
    saveTokenUrlRequest.httpMethod = HTTPRequestMethod.post
    saveTokenUrlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
    saveTokenUrlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
    saveTokenUrlRequest.setValue("Bearer \(self.storageService.loadUserSecret() ?? "")", forHTTPHeaderField: "authentication")

    do {
      let jsonData = try JSONEncoder().encode(saveToken)
      saveTokenUrlRequest.httpBody = jsonData
    } catch {
      print("\(logTag): Error cannot create JSON from saveTokenRequest model")
      completion(error)
      return
    }

    let task = URLSession.shared.dataTask(with: saveTokenUrlRequest) { _, response, error in
      guard error == nil else {
        print("\(self.logTag): Error calling POST on /token/save")
        print(error!)
        completion(error)
        return
      }
      guard let response = response as? HTTPURLResponse else {
        print("\(self.logTag): Error failed response")
        completion(APIError.noData)
        return
      }

      if response.statusCode == 204 || response.statusCode == 200 {
        completion(nil)
        return
      }
      print("\(self.logTag): Error parsing response from POST on /token/save")
      completion(APIError.parseError)
      return
    }
    task.resume()
  }

  internal func registerAccount(registerAccount: RegisterAccountRequest, completion: @escaping (RegisterAccountResponse?, Error?) -> Void) {
    guard let registerURL = URL(string: "\(Environment.rootURL)/api/v1/account/register") else {
      preconditionFailure("\(logTag): Error cannot create URL for registering account")
    }

    var registerUrlRequest = URLRequest(url: registerURL)
    registerUrlRequest.httpMethod = HTTPRequestMethod.post
    registerUrlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
    registerUrlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")

    do {
      let jsonData = try JSONEncoder().encode(registerAccount)
      registerUrlRequest.httpBody = jsonData
    } catch let error {
      print("\(logTag): Error cannot create JSON from registerAccount model")
      completion(nil, error)
      return
    }

    let task = URLSession.shared.dataTask(with: registerUrlRequest) { data, _, error in
      guard error == nil else {
        print("\(self.logTag): Error calling POST on /account/register")
        print(error!)
        completion(nil, error)
        return
      }

      guard let responseData = data else {
        print("\(self.logTag): Error did not receive data")
        completion(nil, APIError.noData)
        return
      }

      // parse the result as JSON, since that's what the API provides
      do {
        let registerAccountResponse = try JSONDecoder().decode(RegisterAccountResponse.self, from: responseData)
        print("The ID is: \(registerAccountResponse.id)")
        print("The Secret is: \(registerAccountResponse.secret)")
        completion(registerAccountResponse, nil)
      } catch {
        print("\(self.logTag): Error parsing response from POST on /account/register")
        completion(nil, APIError.parseError)
        return
      }
    }
    task.resume()
  }
}
