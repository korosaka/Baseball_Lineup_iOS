//
//  CustomTabViewController.swift
//  BaseballLineupIOS
//
//  Created by Koro Saka on 2020-12-07.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import UIKit
import GRDB
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
        viewModel?.delegate = self
        
        // MARK: child views
        for vc in self.viewControllers! {
            if let controller: OrderViewController = vc as? OrderViewController {
                controller.viewModel?.orderType = self.viewModel?.orderType
                controller.viewModel?.cacheData = self.viewModel?.cacheData
                controller.viewModel?.helper = self.viewModel?.helper
                controller.parentViewModel = self.viewModel
            }
            if let controller: SubMemberViewController = vc as? SubMemberViewController {
                controller.viewModel?.orderType = self.viewModel?.orderType
                controller.viewModel?.cacheData = self.viewModel?.cacheData
                controller.viewModel?.helper = self.viewModel?.helper
                controller.parentViewModel = self.viewModel
            }
            if let controller: FieldViewController = vc as? FieldViewController {
                controller.viewModel?.orderType = self.viewModel?.orderType
                controller.viewModel?.cacheData = self.viewModel?.cacheData
                controller.viewModel?.setup()
            }
        }
    }
}

extension CustomTabBarController: CustomTabBarVMDelegate {
    func switchScreen(_ screenIndex: Int) {
        let controllerToGoTo = self.viewControllers?[screenIndex]
        self.selectedViewController = controllerToGoTo
        
        if let controller: OrderViewController = selectedViewController as? OrderViewController {
            controller.prepareToExchangeWithSub()
        }
        
    }
    
    func reloadTables() {
        for vc in self.viewControllers! {
            if let controller: OrderViewController = vc as? OrderViewController {
                controller.reloadOrder()
            }
            if let controller: SubMemberViewController = vc as? SubMemberViewController {
                controller.reloadOrder()
            }
        }
    }
    
    func setUIDefault() {
        for vc in self.viewControllers! {
            if let controller: OrderViewController = vc as? OrderViewController {
                controller.setUIDefault()
            }
            if let controller: SubMemberViewController = vc as? SubMemberViewController {
                controller.setDefaultUI()
            }
        }
    }
    
    func updateStartingSub(db: Database,
                           startingNum: OrderNum,
                           startingPlayer: StartingPlayer,
                           subPlayer: SubPlayer) throws {
        for vc in self.viewControllers! {
            if let controller: OrderViewController = vc as? OrderViewController {
                try controller.viewModel?.updateStartingTable(db, orderNum: startingNum, newData: startingPlayer)
            }
            if let controller: SubMemberViewController = vc as? SubMemberViewController {
                try controller.viewModel?.updateSubTable(db, newData: subPlayer)
            }
        }
    }
}
