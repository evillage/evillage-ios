//
//  TokenInteractor.swift
//  ClangNotifications
//
//  Created by Tetiana Padalko on 06/11/2019.
//  Copyright © 2019 Worth Internet Systems. All rights reserved.
//

import Foundation


protocol TokenInteractorProtocol: class {
    func sendTokenToServer(firebaseToken: String, completion: @escaping (Error?) -> Swift.Void)
}

class TokenInteractor: TokenInteractorProtocol {
    
    let serverService: ServerServiceProtocol = ServerService()
    let storageService: StorageServiceProtocol = StorageService()
    
    func sendTokenToServer(firebaseToken: String, completion: @escaping (Error?) -> Swift.Void) {
        
        let userId = storageService.loadUserId()
        let tokenRequest = SaveTokenRequest(userId: userId!, token: firebaseToken)
        
        serverService.saveToken(saveToken: tokenRequest) { (error) in
            if error != nil {
                print(error!)
                completion(error)
                return
            } else {
                completion(nil)
                return
            }
        }
    }
}
