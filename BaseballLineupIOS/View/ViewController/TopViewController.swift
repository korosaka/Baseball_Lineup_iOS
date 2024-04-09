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
import GoogleMobileAds

class TopViewController: UIViewController {
    
    var viewModel: TopViewModel?
    private var isDoneTrackingCheck = false
    private var isShownInterstitial = false
    private var interstitial: GADInterstitialAd?
    private var indicator: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewModel = .init()
        createIndicator()
    }
    
    private func createIndicator() {
        indicator = UIActivityIndicatorView()
        if let _indicator = indicator {
            _indicator.center = view.center
            _indicator.style = .large
            _indicator.color = .systemPink
            view.addSubview(_indicator)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !isDoneTrackingCheck { requestIDFA() } // showing Interstitial is only once!
    }
    
    @IBAction func onClickNoDH(_ sender: Any) {
        onClickOrderType(type: .Normal)
    }
    
    @IBAction func onClickDH(_ sender: Any) {
        onClickOrderType(type: .DH)
    }
    
    private func onClickOrderType(type: OrderType) {
        if isDoneTrackingCheck {
            showInterstitial()
            performSegue(withIdentifier: "goOrderScreen", sender: type)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        viewModel?.informOrderType(segue: segue, sender: sender)
    }
    
    /*
     ref: https://developers.google.com/admob/ios/ios14#request
     */
    func requestIDFA() {
        indicator?.startAnimating()
        Thread.sleep(forTimeInterval: 0.1) //to fix the bug of not showing tracking request: https://qiita.com/renave/items/b408aad151df722be747
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                self.loadInterstitialAd()
            })
        } else {
            loadInterstitialAd()
        }
    }
    
    private func loadInterstitialAd() {
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID: Constants.INTERSTITIAL_ID,
                               request: request,
                               completionHandler: { [self] ad, error in
                                self.isDoneTrackingCheck = true
                                indicator?.stopAnimating()
                                if let error = error {
                                    print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                                    return
                                }
                                interstitial = ad
                               }
        )
    }
    
    private func showInterstitial() {
        if isShownInterstitial { return }
        if let _interstitial = interstitial {
            _interstitial.present(fromRootViewController: self)
            isShownInterstitial = true
        } else {
            print("Ad wasn't ready")
        }
    }
}

