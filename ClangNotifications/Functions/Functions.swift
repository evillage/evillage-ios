//
//  Functions.swift
//  ClangNotifications
//
//  Created by Jeffrey Snijder on 15/10/2021.
//  Copyright © 2021 Worth Internet Systems. All rights reserved.
//

import Foundation
import UIKit
public class ClangFunctions {
    public init() {}
    
    public func convertJSON(toConvert: String) -> String {
 
        let htmlString = base64Decoded(string: toConvert)
        var dictonary: Dictionary<String, Any>?
        if let data = htmlString!.data(using: .utf8) {
            do {
                
                dictonary = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? Dictionary<String, Any>
                
                if let myDictionary = dictonary {
                    let dict = myDictionary["body"] as? Dictionary<String, Any>
                    var body = (dict!["content"] as? String)
                    body = body?.replacingOccurrences(of: "\\", with: "").description
                   
                    return body!

                }
            } catch let error as NSError {
                print(error)
            }
        }
        
        return ""
    }
    
    public func convertDemoJSON(toConvert: String) -> String {
        
        print(toConvert)
        
        var dictonary: Dictionary<String, Any>?
        if let data = toConvert.data(using: .utf8) {
            do {
                
                dictonary = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? Dictionary<String, Any>
                
                if let myDictionary = dictonary {
                    
                    var payload = base64Decoded(string: (myDictionary["payload"] as? String)!)
                    payload = payload?.replacingOccurrences(of: "\\", with: "").description
                    return payload!      
                }
            } catch let error as NSError {
                print(error)
            }
        }
        
        return ""
    }
    public func buildTheTickets(parant: NSObject, toadd: String) {

        if  parant is UINavigationController {
            
            let navigationController = parant as? UINavigationController
            let copyController = navigationController?.viewControllers.last
            var go = true
              
            for view in copyController!.view.subviews {

                if view .isKind(of: TicketCollectionView.self) {
                    go = false
                    let originals = copyController!.view.subviews.compactMap { $0 as? TicketCollectionView }
                    originals.first?.buildTheTickets(stringtoAdd: toadd)
                }
            }
            
            if go {
              let ticketCollectionView = TicketCollectionView(frame: CGRect(x: 0, y: 80, width: copyController!.view.frame.size.width, height: (copyController!.view.frame.size.height/3)))
              ticketCollectionView.build(json: toadd, parant: copyController!)
              ticketCollectionView.buildTheTickets(stringtoAdd: toadd)
            }
            
        } else {
            
            let viewController = UIApplication.shared.keyWindow?.rootViewController
            let copyController = viewController
            var go = true
              
            for view in copyController!.view.subviews {

                if view .isKind(of: TicketCollectionView.self) {
                    go = false
                    let originals = copyController!.view.subviews.compactMap { $0 as? TicketCollectionView }
                    originals.first?.buildTheTickets(stringtoAdd: toadd)
                }
            }
            
            if go {
              let ticketCollectionView = TicketCollectionView(frame: CGRect(x: 0, y: 80, width: copyController!.view.frame.size.width, height: (copyController!.view.frame.size.height/3)))
              ticketCollectionView.build(json: toadd, parant: copyController!)
              ticketCollectionView.buildTheTickets(stringtoAdd: toadd)
            }
            
        }
       
    }
    
    public func base64Encoded(string: String) -> String? {
        if let data = string.data(using: .utf8) {
            return data.base64EncodedString()
        }
        return nil
    }

    public func base64Decoded(string: String) -> String? {
       if let data = Data(base64Encoded: string, options: .ignoreUnknownCharacters) {
           return String(data: data, encoding: .utf8)
       }
       return nil
   }
    
}
