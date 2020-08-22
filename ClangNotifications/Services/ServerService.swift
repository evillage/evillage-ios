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
private enum HTTPRequestMethod: String {
  case post = "POST"
  case get = "GET"
}

/// APIErrors that coud be generated when performing API calls
enum APIError: Error {
  /// When the API call returns with noData this API error will be returned
  case noData
  /// When the API call returns but data can't be parsed back to JSON this error will be returned
  case parseError
  /// When the HTTPURLResponse statuscode  is NOT 200 or 204 we will return this error containing the statuscode
  case httpError(code: Int)
}

protocol ServerServiceProtocol: class {
  /// Perform an RegisterAccount API call that will register this device in the Clang backend
  /// - Parameters:
  ///   - registerAccount: The RegisterAccount object which will be decoded to JSON and added to the body of this request
  ///   - completion: The completion handler which will trigger when the request is either completed or failed. The completion handler will either contain a RegisterAccountResponse object or an Error object.
  func registerAccount(registerAccount: RegisterAccountRequest, completion: @escaping (RegisterAccountResponse?, Error?) -> Void)

  /// Perform an SaveToken API call to save the Firebase token on the Clang backend
  /// - Parameters:
  ///   - saveToken: The SaveTokenRequest object which will be decoded to JSON and added to the body of this request
  ///   - completion: The completion handler which will trigger when the request is either completed or failed.
  func saveToken(saveToken: SaveTokenRequest, completion: @escaping (Error?) -> Void)

  /// Perform a LogNotificationAction API call which will log a given NotificationEvent in the Clang backend
  /// - Parameters:
  ///   - notificationAction: The NotificationActionRequest object which will be decoded to JSON and added to the body of this request
  ///   - completion: The completion handler which will trigger when the request is either completed or failed
  func logNotificationAction(notificationAction: NotificationActionRequest, completion: @escaping (Error?) -> Void)

  /// Perform an LogEvent API call which will log a given event in the Clang backend
   /// - Parameters:
   ///   - eventLog: The EventLogRequest object which will be decoded to JSON and added to the body of this request
   ///   - completion: The completion handler which will trigger when the request is either completed or failed
  func logEvent(eventLog: EventLogRequest, completion: @escaping (Error?) -> Void)

  /// Perform an UpdateProperties API call that will update given key/value properties on the Clang backend
  /// - Parameters:
  ///   - propertiesRequest: The PropertiesRequest object which will be decoded to JSON and added to the body of this request
  ///   - completion: The completion handler which will trigger when the request is either completed or failed.
  func updateProperties(propertiesRequest: PropertiesRequest, completion: @escaping (Error?) -> Void)
}

class ServerService: ServerServiceProtocol {

  /// Create a storageService object to easily access the keychain
  private let storageService: StorageServiceProtocol = StorageService()

  /// Tag to used in debug prints for easy search in Xcode debug console
  private let logTag: String = "\(ServerService.self)"

  // MARK: - Private methods

  /// Generate an URLRequest with default headerfields
  /// - Parameters:
  ///   - url: The URL we need to create the URLRequest
  ///   - httpMethod: The HTTPRequest method (e.g. POST, GET e.t.c.)
  private func generateURLRequest(url: URL, httpMethod: HTTPRequestMethod) -> URLRequest {
    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = httpMethod.rawValue
    urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
    urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
    urlRequest.setValue("Bearer \(Environment.authorizationToken)", forHTTPHeaderField: "Authorization")
    return urlRequest
  }

  // MARK: - ServerServiceProtocol methods

  /// Perform a LogNotificationAction API call which will log a given NotificationEvent in the Clang backend
  /// - Parameters:
  ///   - notificationAction: The NotificationActionRequest object which will be decoded to JSON and added to the body of this request
  ///   - completion: The completion handler which will trigger when the request is either completed or failed
  internal func logNotificationAction(notificationAction: NotificationActionRequest, completion: @escaping (Error?) -> Void) {
    guard let url = URL(string: "\(Environment.baseURL)/push/notification/action") else {
      preconditionFailure("\(logTag): Error cannot create URL for logging notifications")
    }

    var urlRequest = generateURLRequest(url: url, httpMethod: .post)

    do {
      urlRequest.httpBody = try JSONEncoder().encode(notificationAction)
    } catch let error {
      print("\(logTag): Error cannot create JSON from NotificationActionRequest entity")
      completion(error)
      return
    }

    let task = URLSession.shared.dataTask(with: urlRequest) { _, response, error in
      guard error == nil else {
        print("\(self.logTag): Error calling POST on /notification/action with error: \(error!)")
        completion(error)
        return
      }

      guard let response = response as? HTTPURLResponse else {
        print("\(self.logTag): Error failed response")
        completion(APIError.noData)
        return
      }

      guard response.statusCode == 200 || response.statusCode == 204 else {
        print("\(self.logTag): Error parsing response from POST on /notification/action with code: \(response.statusCode)")
        completion(APIError.httpError(code: response.statusCode))
        return
      }

      print("\(self.logTag): Succesfully posted /notification/action")
      completion(nil)
    }
    task.resume()
  }

  /// Perform an LogEvent API call which will log a given event in the Clang backend
  /// - Parameters:
  ///   - eventLog: The EventLogRequest object which will be decoded to JSON and added to the body of this request
  ///   - completion: The completion handler which will trigger when the request is either completed or failed
  internal func logEvent(eventLog: EventLogRequest, completion: @escaping (Error?) -> Void) {
    guard let url = URL(string: "\(Environment.baseURL)/push/notification/event") else {
      preconditionFailure("\(logTag): Error cannot create URL for event logging")
    }

    var urlRequest = generateURLRequest(url: url, httpMethod: .post)

    do {
      urlRequest.httpBody = try JSONEncoder().encode(eventLog)
    } catch {
      print("\(logTag): Error cannot create JSON from EventLogRequest entity")
      completion(error)
      return
    }

    let task = URLSession.shared.dataTask(with: urlRequest) { _, response, error in
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

      guard response.statusCode == 200 || response.statusCode == 204 else {
        print("\(self.logTag): Error parsing response from POST on /notification/event with code: \(response.statusCode)")
        completion(APIError.httpError(code: response.statusCode))
        return
      }

      print("\(self.logTag): Successfully did POST on /notification/event")
      completion(nil)
    }
    task.resume()
  }

  /// Perform an SaveToken API call to save the Firebase token on the Clang backend
  /// - Parameters:
  ///   - saveToken: The SaveTokenRequest object which will be decoded to JSON and added to the body of this request
  ///   - completion: The completion handler which will trigger when the request is either completed or failed.
  internal func saveToken(saveToken: SaveTokenRequest, completion: @escaping (Error?) -> Void) {
    guard let url = URL(string: "\(Environment.baseURL)/push/token/save") else {
      preconditionFailure("Error cannot create URL for saving token")
    }

    var urlRequest = generateURLRequest(url: url, httpMethod: .post)

    do {
      urlRequest.httpBody = try JSONEncoder().encode(saveToken)
    } catch {
      print("\(logTag): Error cannot create JSON from SaveTokenRequest entity")
      completion(error)
      return
    }

    let task = URLSession.shared.dataTask(with: urlRequest) { _, response, error in
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

      guard response.statusCode == 200 || response.statusCode == 204 else {
        print("\(self.logTag): Error parsing response from POST on /token/save with code: \(response.statusCode)")
        completion(APIError.httpError(code: response.statusCode))
        return
      }

      completion(nil)
    }
    task.resume()
  }

  /// Perform an RegisterAccount API call that will register this device in the Clang backend
  /// - Parameters:
  ///   - registerAccount: The RegisterAccount object which will be decoded to JSON and added to the body of this request
  ///   - completion: The completion handler which will trigger when the request is either completed or failed. The completion handler will either contain a RegisterAccountResponse object or an Error object.
  internal func registerAccount(registerAccount: RegisterAccountRequest, completion: @escaping (RegisterAccountResponse?, Error?) -> Void) {
    guard let url = URL(string: "\(Environment.baseURL)/push/account/register") else {
      preconditionFailure("\(logTag): Error cannot create URL for registering account")
    }

    var urlRequest = generateURLRequest(url: url, httpMethod: .post)

    do {
      urlRequest.httpBody = try JSONEncoder().encode(registerAccount)
    } catch let error {
      print("\(logTag): Error cannot create JSON from RegisterAccountRequest entity")
      completion(nil, error)
      return
    }

    let task = URLSession.shared.dataTask(with: urlRequest) { data, _, error in
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
        let json = String(data: responseData, encoding: String.Encoding.utf8)
        print("\(self.logTag): Got back \(String(describing: json))")
        let registerAccountResponse = try JSONDecoder().decode(RegisterAccountResponse.self, from: responseData)
        print("The ID is: \(registerAccountResponse.id)")
        completion(registerAccountResponse, nil)
      } catch let error {
        print("\(self.logTag): Error parsing response from POST on /account/register with error: \(error.localizedDescription)")
        completion(nil, APIError.parseError)
      }
    }
    task.resume()
  }

  /// Perform an UpdateProperties API call that will update given key/value properties on the Clang backend
  /// - Parameters:
  ///   - propertiesRequest: The PropertiesRequest object which will be decoded to JSON and added to the body of this request
  ///   - completion: The completion handler which will trigger when the request is either completed or failed.
  internal func updateProperties(propertiesRequest: PropertiesRequest, completion: @escaping (Error?) -> Void) {
    guard let url = URL(string: "\(Environment.baseURL)/push/properties") else {
      preconditionFailure("\(logTag): Error cannot create URL for updating properties")
    }

    var urlRequest = generateURLRequest(url: url, httpMethod: .post)

    do {
      urlRequest.httpBody = try JSONEncoder().encode(propertiesRequest)
    } catch let error {
      print("\(self.logTag): Error can't create JSON from PropertiesRequest entity")
      completion(error)
      return
    }

    let task = URLSession.shared.dataTask(with: urlRequest) { _, response, error in
      guard error == nil else {
        print("\(self.logTag): Error calling POST on /properties with error: \(error!)")
        completion(error)
        return
      }

      guard let response = response as? HTTPURLResponse else {
        print("\(self.logTag): Error failed response")
        completion(APIError.noData)
        return
      }

      guard response.statusCode == 200 || response.statusCode == 204 else {
        print("\(self.logTag): Error parsing response from POST on /token/save")
        completion(APIError.httpError(code: response.statusCode))
        return
      }

      completion(nil)
    }
    task.resume()
  }
}
