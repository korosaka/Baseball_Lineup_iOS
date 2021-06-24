//
//  ViewController.swift
//  BaseballLineupIOS
//
//  Created by Koro Saka on 2020-11-02.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import UIKit
import AppTrackingTransparency
import AdSupport

class TopViewController: UIViewController {
    
    var viewModel: TopViewModel?
    var isDoneTrackingCheck = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewModel = .init()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        requestIDFA()
    }
    
    @IBAction func onClickNoDH(_ sender: Any) {
        if isDoneTrackingCheck {
            performSegue(withIdentifier: "goOrderScreen", sender: OrderType.Normal)
        }
    }
    
    @IBAction func onClickDH(_ sender: Any) {
        if isDoneTrackingCheck {
            performSegue(withIdentifier: "goOrderScreen", sender: OrderType.DH)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        viewModel?.informOrderType(segue: segue, sender: sender)
    }
    
    /*
     ref: https://developers.google.com/admob/ios/ios14#request
     */
    func requestIDFA() {
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                self.isDoneTrackingCheck = true
                // Tracking authorization completed. Start loading ads here.
                // loadAd()
            })
        } else {
            isDoneTrackingCheck = true
            // Fallback on earlier versions
        }
    }
}

