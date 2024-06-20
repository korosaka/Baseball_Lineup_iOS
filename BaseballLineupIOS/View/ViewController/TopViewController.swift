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
import StoreKit

class TopViewController: UIViewController {
    
    var viewModel: TopViewModel?
    private var isDoneTrackingCheck = false
    private var isShownInterstitial = false
    private var interstitial: GADInterstitialAd?
    private var indicator: UIActivityIndicatorView?
    
    @IBOutlet weak var specialOrderButton: UIButton!
    @IBOutlet weak var purchaseButton: UIButton!
    
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
    
    @IBAction func onClickSpecial(_ sender: Any) {
        onClickOrderType(type: .Special)
    }
    
    
    @IBAction func onClickPurchase(_ sender: Any) {
        
        Task {
            var alertDialog: UIAlertController? = nil
            
            await viewModel?.getAllHitterProduct { result in
                switch result {
                case .success(let product):
                    alertDialog = UIAlertController(title:product.displayName, message:"\(product.description) \n\n価格:\(product.displayPrice)\n買い切りですので支払いは1度きりです。\nサブスクではありませんのでご安心ください。", preferredStyle:UIAlertController.Style.alert)
                    
                    alertDialog?.addAction(UIAlertAction(title: "購入手続へ", style:UIAlertAction.Style.default){
                        (action:UIAlertAction)in
                        
                    })
                    
                    alertDialog?.addAction(UIAlertAction(title: "キャンセル", style:UIAlertAction.Style.cancel){
                        (action:UIAlertAction)in
                        
                    })
                case .failure(_):
                    alertDialog = UIAlertController(title: "エラー",
                                                  message: "インターネットの通信状態を確認してください。\n時間をおいてもう一度お試しください。",
                                                  preferredStyle: UIAlertController.Style.alert)
                    alertDialog?.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                }
            }
            
            Task {@MainActor in
                guard let _dialog = alertDialog else { return }
                self.present(_dialog, animated: true, completion:nil)
            }
        }
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
        Thread.sleep(forTimeInterval: 0.5) //to fix the bug of not showing tracking request: https://qiita.com/renave/items/b408aad151df722be747
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

