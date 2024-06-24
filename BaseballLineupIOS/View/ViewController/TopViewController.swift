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
    @IBOutlet weak var restoreButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewModel = .init()
        createIndicator()
        checkPurchasingState()
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
    
    private var isIndicatorAnimating: Bool {
        get {
            guard let _indicator = indicator else { return false }
            return _indicator.isAnimating
        }
    }
    
    private func checkPurchasingState() {
        guard let vm = viewModel else { return }
        let purchased = UsingUserDefaults.isSpecialPurchased
        specialOrderButton.setTitle(vm.getSpecialOrderButttonText(purchased: purchased), for: .normal)
        specialOrderButton.isEnabled = purchased
        purchaseButton.isHidden = purchased
        restoreButton.isHidden = purchased
        specialOrderButton.setTitleColor(vm.getSpecialOrderButttonTextColor(purchased: purchased), for: .normal)
        specialOrderButton.backgroundColor = vm.getSpecialOrderButttonColor(purchased: purchased)
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
    
    
    @IBAction func onClickRestore(_ sender: Any) {
        
        guard !isIndicatorAnimating, let vm = viewModel else { return }
        indicator?.startAnimating()
        Task {
            await vm.restore { title, message in
                let completionDialog = self.createSimpleAlert(title, message)
                self.addOKToAlert(completionDialog)
                Task {@MainActor in
                    self.indicator?.stopAnimating()
                    self.checkPurchasingState()
                    self.present(completionDialog, animated: true, completion:nil)
                }
            }
        }
    }
    
    @IBAction func onClickPurchase(_ sender: Any) {
        guard !isIndicatorAnimating, let vm = viewModel else { return }
        
        indicator?.startAnimating()
        Task {
            var alertDialog: UIAlertController? = nil
            
            await vm.getAllHitterProduct { result in
                switch result {
                case .success(let product):
                    //TODO: set Privacy policy and terms of service
                    //https://qiita.com/alt_yamamoto/items/334daaa33ff12758d114#%E6%A6%82%E8%A6%81%E6%AC%84%E3%81%AB%E3%83%97%E3%83%A9%E3%82%A4%E3%83%90%E3%82%B7%E3%83%BC%E3%83%9D%E3%83%AA%E3%82%B7%E3%83%BC%E3%81%A8%E5%88%A9%E7%94%A8%E8%A6%8F%E7%B4%84%E3%81%AE%E3%83%AA%E3%83%B3%E3%82%AF%E3%82%92%E8%A8%98%E8%BC%89%E3%81%99%E3%82%8B
                    let allHitterDescription =
                    product.description
                    + Constants.ALL_HITTER_DESC_1
                    + product.displayPrice
                    + Constants.ALL_HITTER_DESC_2
                    
                    alertDialog = self.createSimpleAlert(product.displayName, allHitterDescription)
                    
                    alertDialog?.addAction(UIAlertAction(title: Constants.GO_TO_PURCHASE, style:UIAlertAction.Style.default){
                        (action:UIAlertAction)in
                        self.startPurchaseFlow(product: product)
                    })
                    alertDialog?.addAction(UIAlertAction(title: Constants.TITLE_CANCEL, style:UIAlertAction.Style.cancel, handler: nil))
                    
                case .failure(_):
                    alertDialog = self.createSimpleAlert(Constants.TITLE_ERROR, Constants.FAIL_FETCH_PRODUCT)
                    self.addOKToAlert(alertDialog)
                }
            }
            
            Task {@MainActor in
                self.indicator?.stopAnimating()
                guard let _dialog = alertDialog else { return }
                self.present(_dialog, animated: true, completion:nil)
            }
        }
    }
    
    private func createSimpleAlert(_ title: String, _ message: String) -> UIAlertController {
        UIAlertController(title: title,
                          message: message,
                          preferredStyle: UIAlertController.Style.alert)
    }
    
    private func addOKToAlert(_ alert: UIAlertController?) {
        alert?.addAction(UIAlertAction(title: Constants.OK, style: .default, handler: nil))
    }
    
    private func startPurchaseFlow(product: Product) {
        guard !isIndicatorAnimating, let vm = viewModel else { return }
        indicator?.startAnimating()
        Task {
            await vm.purchaseItem(product) { title, message in
                let completionDialog = self.createSimpleAlert(title, message)
                self.addOKToAlert(completionDialog)
                Task {@MainActor in
                    self.indicator?.stopAnimating()
                    self.present(completionDialog, animated: true, completion:nil)
                }
            }
        }
    }
    
    private func onClickOrderType(type: OrderType) {
        if isDoneTrackingCheck, !isIndicatorAnimating {
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

