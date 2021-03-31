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
    
    func loadBannerAd() {
        print("this function must be overridden.")
    }
    
    func getViewWidth() -> CGFloat {
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
