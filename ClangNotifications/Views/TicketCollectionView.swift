//
//  TicketCollectionView.swift
//  ClangNotifications
//
//  Created by Jeffrey Snijder on 15/10/2021.
//  Copyright © 2021 Worth Internet Systems. All rights reserved.
//

import Foundation
import UIKit

open class TicketCollectionView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var paranting: NSObject!
    var frameCopy: CGRect!
    open var listOftickets = Array<String>()
    open var reversetickets = Array<String>()
    open lazy var collectionView: UICollectionView = {
        
        let copyController = paranting as? UIViewController
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: self.frame.width, height: copyController!.view.frame.size.height/3)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 5, width: self.frame.width, height: copyController!.view.frame.size.height/3), collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "TicketCollectionCell")
        collectionView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 5, right: 0)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        return collectionView
    }()
    
    open lazy var bullets: UIPageControl = {
    
        let copyController = paranting as? UIViewController
        let pageControl = UIPageControl(frame: CGRect(x: (self.frame.width-200)/2, y: (copyController!.view.frame.size.height/3)-50, width: 200, height: 10))
        pageControl.numberOfPages = listOftickets.count
        pageControl.pageIndicatorTintColor = .gray
        pageControl.currentPageIndicatorTintColor = .black
        self.addSubview( pageControl )
        pageControl.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        
        return pageControl
    }()
    
    open lazy var bottumScroll: UIScrollView = {
        
        let scrollview = UIScrollView()
        scrollview.backgroundColor = .clear
        scrollview.isScrollEnabled = true
        scrollview.isUserInteractionEnabled = true
        
        return scrollview
    }()
    
    public func buildTheTickets(stringtoAdd: String) {
        
        if stringtoAdd.count > 2 {
        listOftickets.append(stringtoAdd)
     
        print("buildTheTickets", listOftickets)
        reversetickets = listOftickets.reversed()
        collectionView.reloadData()
        bullets.numberOfPages = listOftickets.count
            
        }
    }
    
    public func reverseit() {
        
        reversetickets = listOftickets.reversed()
    }
    
    public func build(json: String, parant: NSObject) {
           
        paranting = parant
        let copyController = parant as? UIViewController
            
            self.backgroundColor = .white
            copyController!.view.addSubview(self)
            self.alpha = 1
           
            self.addSubview(collectionView)
            self.addSubview(bullets)
            collectionView.dataSource = self
            collectionView.delegate = self
            movingAll(parant: parant)
                
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reversetickets.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TicketCollectionCell",
                                                      for: indexPath)
        
        for item in cell.subviews {
            
            item.removeFromSuperview()
        }
        
        print( listOftickets[indexPath.row])

        let copyController = paranting as? UIViewController
        let ticket = TicketView(frame: CGRect(x: 9, y: 2, width: copyController!.view.frame.size.width-20, height: (copyController!.view.frame.size.height/3)-20))
        ticket.buildForCollection(json: reversetickets[indexPath.row], parant: paranting)
        ticket.backgroundColor = .white
        cell.addSubview(ticket)
        ticket.alpha = 1
        
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        bullets.currentPage = indexPath.item
    }
    
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
    
    func movingAll(parant: NSObject) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) { [self] in // Change `2.0` to the desired number of seconds.
            
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
                    for item in copyView.subviews {
                        if item .isKind(of: TicketCollectionView.self) {
                            
                            item.removeFromSuperview()
                        }
                        
                    }
                    bottumScroll.frame = CGRect(x: 0, y: self.frame.size.height+100, width: copyController!.view.frame.size.width, height: 400)
                    bottumScroll.contentSize = CGSize(width: copyController!.view.frame.size.width, height: copyController!.view.frame.size.height)
                    bottumScroll.addSubview(copyView)
                    
                    for item in copyController!.view.subviews {
                        
                        if item is Self {
                            item.alpha = 1
                        } else {
                            item.alpha = 0
                        }
                        
                    }
                    print(copyView.subviews)
                    copyController!.view.insertSubview(bottumScroll, belowSubview: self)
                    
                }
            }
        }
    }
    
}
