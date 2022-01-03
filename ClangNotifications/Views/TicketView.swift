//  TicketView.swift
//  ClangNotifications
//
//  Created by Jeffrey Snijder on 30/09/2021.
//  Copyright © 2021 Worth Internet Systems. All rights reserved.
//

import Foundation
import UIKit
import WebKit

public class TicketView: UIView, WKUIDelegate, WKNavigationDelegate {
    
    var paranting: NSObject!
    var frameCopy: CGRect!
    /// build WKWebView
    ///
    open lazy var webView: WKWebView = {
        webView = WKWebView(frame: CGRect(x: 20, y: 20, width: self.frame.size.width-40, height: self.frame.size.height-40))
        webView.backgroundColor = .clear
        webView.uiDelegate = self
        webView.isOpaque = false
        webView.navigationDelegate = self
        webView.scrollView.isScrollEnabled = false
        
        return webView
    }()
    /// build UIButton
    ///
    open lazy var gone: UIButton = {
        
        let gone = UIButton(frame: CGRect(x: self.frame.size.width-50, y: 0, width: 50, height: 40))
        gone.setTitle("x", for: .normal)
        gone.titleLabel?.adjustsFontSizeToFitWidth = true
        gone.contentEdgeInsets = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 6)
        gone.setTitleColor(.black, for: .normal)
        gone.addTarget(self, action: #selector(back), for: .touchUpInside)
        gone.layer.cornerRadius = 4
        
        return gone
    }()
    /// build UIScrollView
    ///
    open lazy var bottumScroll: UIScrollView = {
        
        let scrollview = UIScrollView()
        scrollview.backgroundColor = .clear
        scrollview.isScrollEnabled = true
        scrollview.isUserInteractionEnabled = true
        
        return scrollview
    }()
    
    public func buildForCollection(json: String, parant: NSObject) {
        
        self.addSubview(webView)
        webView.loadHTMLString(json, baseURL: nil)
        self.addSubview(gone)
        sizeAdjust()
        paranting = parant
    }
    
    public func build(json: String, parant: NSObject) {
        
        let copyController = parant as? UIViewController
        var go = true
        for view in copyController!.view.subviews {
            if view .isKind(of: TicketView.self) {
                go = false
            }
        }
        
        if go {
            
            let htmlString = base64Decoded(string: json)
            var dictonary: Dictionary<String, Any>?
            if let data = htmlString!.data(using: .utf8) {
                do {
                    
                    dictonary = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? Dictionary<String, Any>
                    
                    if let myDictionary = dictonary {
                        let dict = myDictionary["body"] as? Dictionary<String, Any>
                        var body = (dict!["content"] as? String)
                        body = body?.replacingOccurrences(of: "\\", with: "").description
                        
                        self.addSubview(webView)
                        webView.loadHTMLString(body!, baseURL: nil)
                        self.addSubview(gone)
                        
                        sizeAdjust()
                        
                        movingAll(parant: parant)
                        
                    }
                } catch let error as NSError {
                    print(error)
                }
            }
            paranting = parant
        }
    }
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
            if navigationAction.navigationType == .linkActivated  {
                if let url = navigationAction.request.url,
                    UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url)
              
                    decisionHandler(.cancel)
                } else {
                    print("Open it locally")
                    decisionHandler(.allow)
                }
            } else {
                print("not a user click")
                decisionHandler(.allow)
            }
        }
    
    func movingAll(parant: NSObject) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { [self] in // Change `2.0` to the desired number of seconds.
            
            webView.sizeToFit()
            
            if parant is UIViewController {
                let copyController = parant as? UIViewController
                
                if copyController?.view.subviews.count == 2 {
                    
                    paranting = parant as? UIViewController
                    self.alpha = 1
                    
                    for item in copyController!.view.subviews {
                        
                        if item is UIScrollView {
                            
                            frameCopy = CGRect(x: item.frame.origin.x, y: item.frame.origin.y, width: item.frame.size.width, height: item.frame.size.height)
                            item.frame = CGRect(x: 0, y: self.frame.size.height+100, width: copyController!.view.frame.size.width, height: (copyController!.view.frame.size.height - (self.frame.size.height)))
                        }
                        
                        if item is UITableView {
                            
                            frameCopy = CGRect(x: item.frame.origin.x, y: item.frame.origin.y, width: item.frame.size.width, height: item.frame.size.height)
                            item.frame = CGRect(x: 0, y: self.frame.size.height+100, width: copyController!.view.frame.size.width, height: (copyController!.view.frame.size.height - (self.frame.size.height)))
                        }
                    }
                    
                } else {
                    let copyView =  copyView(view: (copyController?.view)!)
                    bottumScroll.frame = CGRect(x: 0, y: self.frame.size.height+100, width: copyController!.view.frame.size.width, height: (copyController!.view.frame.size.height - (copyController!.view.frame.size.height-100)))
                    bottumScroll.contentSize = CGSize(width: copyController!.view.frame.size.width, height: copyController!.view.frame.size.height)
                    bottumScroll.addSubview(copyView)
                    for item in copyController!.view.subviews {
                        
                        if item is Self {
                            item.alpha = 1
                        } else {
                            item.alpha = 0
                        }
                        
                    }
                    copyController!.view.insertSubview(bottumScroll, belowSubview: self)
                    
                }
            }
        }
    }
    
    func sizeAdjust() {
        var frame = self.frame
        frame.size.height = (self.subviews.last?.frame.size.height)! + (self.subviews.last?.frame.origin.y)! + (20.0)
        self.frame = frame
        
    }
    
    func base64Encoded(string: String) -> String? {
        if let data = string.data(using: .utf8) {
            return data.base64EncodedString()
        }
        return nil
    }
    
    func base64Decoded(string: String) -> String? {
        if let data = Data(base64Encoded: string, options: .ignoreUnknownCharacters) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
    
    func calcWidth(array: Array<Any>) -> Int {
        return  (Int(self.frame.size.width)-20)/array.count
    }
    
    ///  Make a copy and also copy all targets
    func copyView(view: UIView) -> UIView {
        
        /// copy UIView  loosing all Targets
        do {
            /// copy targets form original view UIButton in subviews
            let data = try NSKeyedArchiver.archivedData(withRootObject: view, requiringSecureCoding: false)
            if let copiedViewFromData = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? UIView {
                
                for (indexItem, item) in view.subviews.enumerated() {
                    
                    let originals = item.subviews.compactMap { $0 as? UIButton }
                    let copies = (copiedViewFromData.subviews[indexItem].subviews).compactMap { $0 as? UIButton }
                    for (index) in originals.indices {
                        for target in (originals[index]).allTargets {
                            originals[index].actions(forTarget: target, forControlEvent: .touchUpInside)?.forEach { action in
                                copies[index].addTarget(target, action: Selector(action), for: originals[index].allControlEvents)
                            }
                        }
                    }
                }
                
                /// copy targets form original view UIButton in subviews of subviews
                let originalButtons = view.subviews.compactMap { $0 as? UIButton }
                let copieButtons = copiedViewFromData.subviews.compactMap { $0 as? UIButton }
                for (index) in originalButtons.indices {
                    for target in originalButtons[index].allTargets {
                        originalButtons[index].actions(forTarget: target, forControlEvent: .touchUpInside)?.forEach { action in
                            copieButtons[index].addTarget(target, action: Selector(action), for: originalButtons[index].allControlEvents)
                        }
                    }
                }
                
                /// copy targets form original view UISlider in subviews
                let originalSliders = view.subviews.compactMap { $0 as? UISlider }
                let copieSliders = copiedViewFromData.subviews.compactMap { $0 as? UISlider }
                for (index) in originalSliders.indices {
                    for target in originalSliders[index].allTargets {
                        print("target", target)
                        originalSliders[index].actions(forTarget: target, forControlEvent: .valueChanged)?.forEach { action in
                            copieSliders[index].addTarget(target, action: Selector(action), for: originalSliders[index].allControlEvents)
                        }
                    }
                }
                /// copy targets form original view UISwitch in subviews
                let originalSwitches = view.subviews.compactMap { $0 as? UISwitch }
                let copieSwitches = copiedViewFromData.subviews.compactMap { $0 as? UISwitch }
                
                for (index) in originalSwitches.indices {
                    for target in originalSwitches[index].allTargets {
                        print("target", target)
                        originalSwitches[index].actions(forTarget: target, forControlEvent: .valueChanged)?.forEach { action in
                            copieSwitches[index].addTarget(target, action: Selector(action), for: originalSwitches[index].allControlEvents)
                        }
                    }
                }
                
                return copiedViewFromData
            }
        } catch {
            print("Couldn't write file")
        }
        return view
    }
    
    @objc func back(sender: UIButton) {
        
        let copyController = paranting as? UIViewController
        if copyController!.view.subviews.count == 2 {
            
            for item in copyController!.view.subviews {
                
                if item is UIScrollView {
                    item.frame = CGRect(x: 0, y: 0, width: item.frame.size.width, height: (item.frame.size.height + (self.frame.size.height)))
                }
                
                if item is UITableView {
                    item.frame = CGRect(x: 0, y: 0, width: item.frame.size.width, height: (item.frame.size.height + (self.frame.size.height)))
                }
            }
            
        }
        
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
            self.alpha = 0.0
            self.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        }, completion: { _ in
            for view in copyController!.view.subviews {
                
                if view .isKind(of: TicketCollectionView.self) {
                    let originals = copyController!.view.subviews.compactMap { $0 as? TicketCollectionView }
                    let index =  originals.first?.collectionView.indexPath(for: (originals.first?.collectionView.visibleCells.first)!)
                    
                    originals.first?.listOftickets.remove(at: index!.row)
                    originals.first?.reverseit()
                    originals.first?.collectionView.reloadData()
                    originals.first?.bullets.numberOfPages = (originals.first?.listOftickets.count)!
                    
                    if originals.first?.bullets.numberOfPages == 1 {
                        
                        originals.first?.bullets.alpha = 0
                        
                    } else {
                        
                        originals.first?.bullets.alpha = 1
                    }
                    
                    if (originals.first?.listOftickets.count)! == 0 {
                        
                        originals.first?.bottumScroll.removeFromSuperview()
                        originals.first?.removeFromSuperview()
                        for item in copyController!.view.subviews {
                            
                            if item is Self {
                                
                                item.alpha = 0
                            } else {
                                
                                item.alpha = 1
                            }
                        }
                        
                    }
                }
            }
            
        })
    }
    
    ////Get color for future buttons
    func hexStringToUIColor(hex: String) -> UIColor {
        var cString: String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }
        if (cString.count) != 6 {
            return UIColor.gray
        }
        var rgbValue: UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    ////Resize this
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.webView.evaluateJavaScript("document.readyState", completionHandler: { (complete, _) in
            if complete != nil {
                self.webView.evaluateJavaScript("document.body.scrollHeight", completionHandler: { [self] (height, _) in
                    
                    webView.sizeToFit()
                    var fram = self.frame
                    fram.size.height = webView.frame.height + 40
                    self.frame = fram
                    self.layer.corners()
                })
            }
            
        })
    }
}

extension CALayer {
    func corners() {
        self.masksToBounds = false
        self.cornerRadius = 8
        self.shadowColor = UIColor.black.cgColor
        self.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.cornerRadius).cgPath
        self.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.shadowOpacity = 0.5
        self.shadowRadius = 1.0
    }
    func nocorners() {
        self.masksToBounds = false
        self.shadowColor = UIColor.black.cgColor
        self.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.cornerRadius).cgPath
        self.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.shadowOpacity = 0.5
        self.shadowRadius = 1.0
    }
}
