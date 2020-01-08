//
//  ServerService.swift
//  ClangNotifications
//
//  Created by Tetiana Padalko on 05/11/2019.
//  Copyright © 2019 Worth Internet Systems. All rights reserved.
//

import Foundation
import UIKit

protocol ServerServiceProtocol: class {
    func registerAccount(registerAccount: RegisterAccountRequest, completion: @escaping (RegisterAccountResponse?, Error?) -> Swift.Void)
    func saveToken(saveToken: SaveTokenRequest, completion: @escaping (Error?) -> Swift.Void)
    func logNotificationAction(notificationAction: NotificationActionRequest, completion: @escaping (Error?) -> Swift.Void)
    func logEvent(eventLog: EventLogRequest, completion: @escaping (Error?) -> Swift.Void)
}

class ServerService: ServerServiceProtocol {

    let storageService: StorageServiceProtocol = StorageService()

    // MARK: - ServerServiceProtocol methods


    func logNotificationAction(notificationAction: NotificationActionRequest, completion: @escaping (Error?) -> Swift.Void) {
        guard let notificationLogURL = URL(string: URLLogNotification) else {
            print("Error: cannot create URL")
            return
        }
        let secret = self.storageService.loadUserSecret()
        var notificationLogUrlRequest = URLRequest(url: notificationLogURL)
        notificationLogUrlRequest.httpMethod = "POST"
        notificationLogUrlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        notificationLogUrlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        notificationLogUrlRequest.setValue("Bearer \(secret ?? "")", forHTTPHeaderField: "authentication")

        do {
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(notificationAction)
            notificationLogUrlRequest.httpBody = jsonData
        } catch {
            print("Error: cannot create JSON from notificationLog model")
            completion(error)
            return
        }

        let session = URLSession.shared

        let task = session.dataTask(with: notificationLogUrlRequest) {
            (data, response, error) in
            guard error == nil else {
                print("error calling POST on /notification/action")
                print(error!)
                completion(error)
                return
            }
            guard let response = response as? HTTPURLResponse else {
                print("Error: failed response")
                completion(error)
                return
            }

            if (response.statusCode == 204 || response.statusCode == 200) {
                completion(nil)
                return
            } else {
                print("error parsing response from POST on /notification/action")
                completion(error)
                return
            }
        }
        task.resume()

    }

    func logEvent(eventLog: EventLogRequest, completion: @escaping (Error?) -> Swift.Void) {
        guard let eventLogURL = URL(string: URLLogEvent) else {
            print("Error: cannot create URL")
            return
        }
        let secret = self.storageService.loadUserSecret()

        var eventLogUrlRequest = URLRequest(url: eventLogURL)
        eventLogUrlRequest.httpMethod = "POST"
        eventLogUrlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        eventLogUrlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        eventLogUrlRequest.setValue("Bearer \(secret ?? "")", forHTTPHeaderField: "authentication")

        do {
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(eventLog)
            eventLogUrlRequest.httpBody = jsonData
        } catch {
            print("Error: cannot create JSON from eventLog model")
            completion(error)
            return
        }

        let session = URLSession.shared

        let task = session.dataTask(with: eventLogUrlRequest) {
            (data, response, error) in
            guard error == nil else {
                print("error calling POST on /notification/event")
                print(error!)
                completion(error)
                return
            }
            guard let response = response as? HTTPURLResponse else {
                print("Error: failed response")
                completion(error)
                return
            }

            if (response.statusCode == 200) {
                completion(nil)
                return
            } else {
                print("error parsing response from POST on /notification/event")
                completion(error)
                return
            }
        }
        task.resume()
    }

    func saveToken(saveToken: SaveTokenRequest, completion: @escaping (Error?) -> Swift.Void) {
        guard let saveTokenURL = URL(string: URLStoreFirebaseToken) else {
            print("Error: cannot create URL")
            return
        }
        let secret = self.storageService.loadUserSecret()

        var saveTokenUrlRequest = URLRequest(url: saveTokenURL)
        saveTokenUrlRequest.httpMethod = "POST"
        saveTokenUrlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        saveTokenUrlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")
        saveTokenUrlRequest.setValue("Bearer \(secret ?? "")", forHTTPHeaderField: "authentication")

        do {
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(saveToken)
            saveTokenUrlRequest.httpBody = jsonData
        } catch {
            print("Error: cannot create JSON from saveTokenRequest model")
            completion(error)
            return
        }

        let session = URLSession.shared

        let task = session.dataTask(with: saveTokenUrlRequest) {
            (data, response, error) in
            guard error == nil else {
                print("error calling POST on /token/save")
                print(error!)
                completion(error)
                return
            }
            guard let response = response as? HTTPURLResponse else {
                print("Error: failed response")
                completion(error)
                return
            }

            if (response.statusCode == 204 || response.statusCode == 200) {
                completion(nil)
                return
            } else {
                print("error parsing response from POST on /token/save")
                completion(error)
                return
            }
        }
        task.resume()
    }


    func registerAccount(registerAccount: RegisterAccountRequest, completion: @escaping (RegisterAccountResponse?, Error?) -> Swift.Void) {
        guard let registerURL = URL(string: URLRegister) else {
            print("Error: cannot create URL")
            return
        }
        var registerUrlRequest = URLRequest(url: registerURL)
        registerUrlRequest.httpMethod = "POST"
        registerUrlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        registerUrlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Accept")

        do {
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(registerAccount)
            registerUrlRequest.httpBody = jsonData
        } catch {
            print("Error: cannot create JSON from registerAccount model")
            completion(nil, error)
            return
        }

        let session = URLSession.shared

        let task = session.dataTask(with: registerUrlRequest) {
            (data, response, error) in
            guard error == nil else {
                print("error calling POST on /account/register")
                print(error!)
                completion(nil, error)
                return
            }
            guard let responseData = data else {
                print("Error: did not receive data")
                completion(nil, error)
                return
            }

            // parse the result as JSON, since that's what the API provides
            do {
                guard let createAccountResponse = try JSONSerialization.jsonObject(with: responseData,
                        options: []) as? [String: Any] else {
                    print("Could not get JSON from responseData as dictionary")
                    completion(nil, error)
                    return
                }
                print("The response is: " + createAccountResponse.description)

                guard let userId = createAccountResponse["id"] as? String else {
                    print("Could not get id as String from JSON")
                    completion(nil, error)
                    return
                }
                print("The ID is: \(userId)")
                guard let secret = createAccountResponse["secret"] as? String else {
                    print("Could not get secret as String from JSON")
                    completion(nil, error)
                    return
                }
                completion(RegisterAccountResponse(id: userId, secret: secret), nil)
            } catch {
                print("error parsing response from POST on /account/register")
                completion(nil, error)
                return
            }
        }
        task.resume()
    }


    // MARK: - Private methods

    private let URLRegister = "https://firebase-demo.test.worth.systems/api/v1/account/register"
    private let URLStoreFirebaseToken = "https://firebase-demo.test.worth.systems/api/v1/token/save"
    private let URLLogNotification = "https://firebase-demo.test.worth.systems/api/v1/notification/action"
    private let URLLogEvent = "https://firebase-demo.test.worth.systems/api/v1/notification/event"

}
