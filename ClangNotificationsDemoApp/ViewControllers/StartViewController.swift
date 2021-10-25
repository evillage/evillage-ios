//
//  StartViewController.swift
//  ClangNotificationsDemoApp
//
//  Created by Jeffrey Snijder on 05/10/2021.
//  Copyright © 2021 Worth Internet Systems. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import ClangNotifications

class StartViewController: UIViewController {
    
    @IBAction func buildTicket(_ sender: UIButton) {
        
    
        let htmlString = "<!DOCTYPE html><html><head><meta name=\"viewport\"content=\"width=device-width,initial-scale=1.0,maximum-scale=1.0,user-scalable=no\"/><link href=\"https://fonts.googleapis.com/css?family=PT+Sans:400,700\" rel=\"stylesheet\"><style>table {width:100%;font-size:17px;font-family:PT Sans,Helvetica,Arial,sans-serif;color:#003b5a;line-height:24px;}.title{font-size:20px;}.button{text-align:left;color:#00a4a7;font-weight:bold;text-decoration:none;}</style></head><body style=\"background-color:transparent;\"><table><tr><td><table><tr><td width=\"40px;\"><img src=\"https://i.ibb.co/ggbFyTT/Asset-360-10-R.png\" width=\"35px\"></td><td class=\"title\"><b>Particuliere rekening openen</b></td></tr></table></td></tr><tr><td>Naast zakelijk ook privé bij ons bankieren? Druk in de Knab App op het plusje rechtsboven en kies voor ‘betaalrekening’. Stap nu over en ontvang € 50!</td><tr><td class=\"button\"></td></tr></tr></table></body></html>"
        
        //ClangFunctions().buildTheTickets(parent: self, toadd: htmlString)
    }
    
    @IBAction func changeit(_ sender: UISlider) {
        print("test", sender.value)
        
    }
    
}
