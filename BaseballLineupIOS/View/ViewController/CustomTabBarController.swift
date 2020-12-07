//
//  CustomTabViewController.swift
//  BaseballLineupIOS
//
//  Created by Koro Saka on 2020-12-07.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import UIKit
class CustomTabBarController: UITabBarController {
    var viewModel: CustomTabBarViewModel?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!) {
        super.init(nibName: nil, bundle: nil)
        setup()
    }
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }
    
    func setup() {
        viewModel = .init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: child views
        for vc in self.viewControllers! {
            if let controller: OrderViewController = vc as? OrderViewController {
                controller.viewModel?.orderType = self.viewModel?.orderType
                controller.viewModel?.cacheData = self.viewModel?.cacheData
                controller.viewModel?.helper = self.viewModel?.helper
                
                // MARK: TODO
                controller.parentViewModel = self.viewModel
            }
            if let controller: SubMemberViewController = vc as? SubMemberViewController {
                controller.viewModel?.orderType = self.viewModel?.orderType
                controller.viewModel?.cacheData = self.viewModel?.cacheData
                controller.viewModel?.helper = self.viewModel?.helper
                
                // MARK: TODO
                controller.parentViewModel = self.viewModel
            }
            if let controller: FieldViewController = vc as? FieldViewController {
                controller.viewModel?.orderType = self.viewModel?.orderType
                controller.viewModel?.cacheData = self.viewModel?.cacheData
            }
        }
    }
}
