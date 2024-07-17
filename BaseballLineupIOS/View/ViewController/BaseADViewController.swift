//
//  ADBaseViewController.swift
//  BaseballLineupIOS
//
//  Created by Koro Saka on 2021-03-30.
//  Copyright © 2021 Koro Saka. All rights reserved.
//

import UIKit
import GoogleMobileAds
class BaseADViewController: UIViewController {
    
    let bannerAD: GADBannerView = {
        let banner = GADBannerView()
        banner.translatesAutoresizingMaskIntoConstraints = false
        return banner
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bannerAD.adUnitID = Constants.BANNER_ID
        bannerAD.rootViewController = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadBannerAd()
    }
    
    override func viewWillTransition(to size: CGSize,
                                     with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to:size, with:coordinator)
        coordinator.animate(alongsideTransition: { _ in
            self.loadBannerAd()
        })
    }
    
    private func loadBannerAd() {
        bannerAD.adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(getViewWidth())
        bannerAD.load(GADRequest())
    }
    
    private func getViewWidth() -> CGFloat {
        let frame = { () -> CGRect in
            if #available(iOS 11.0, *) {
                return view.frame.inset(by: view.safeAreaInsets)
            } else {
                return view.frame
            }
        }()
        
        return frame.size.width
    }
}
