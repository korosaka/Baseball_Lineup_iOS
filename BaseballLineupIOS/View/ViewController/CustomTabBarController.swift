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
    
    private func setup() {
        viewModel = .init()
        viewModel?.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setRightBarButtonItem()
        tabBar.backgroundColor = .white
    }
    
    func setupViewControllers(_ orderType: OrderType) {
        viewModel?.orderType = orderType
        
        let orderVC = OrderViewController()
        orderVC.viewModel?.orderType = orderType
        orderVC.viewModel?.cacheData = viewModel?.cacheData
        orderVC.viewModel?.helper = viewModel?.helper
        orderVC.parentViewModel = viewModel
        let orderTabTag = 0
        orderVC.tabBarItem = UITabBarItem(title: "作成", image: UIImage(named: "pen_paper_icon"), tag: orderTabTag)
        
        let startingMemberListVC = StartingMemberListViewController()
        startingMemberListVC.viewModel?.orderType = orderType
        startingMemberListVC.viewModel?.cacheData = viewModel?.cacheData
        let startingListTabTag = 1
        startingMemberListVC.tabBarItem = UITabBarItem(title: "スタメン表", image: UIImage(named: "paper_icon"), tag: startingListTabTag)
        
        let  fieldVC = FieldViewController()
        fieldVC.viewModel?.orderType = orderType
        fieldVC.viewModel?.cacheData = viewModel?.cacheData
        let fieldTabTag = 2
        fieldVC.tabBarItem = UITabBarItem(title: "フィールド", image: UIImage(named: "pin_icon"), tag: fieldTabTag)
        
        let subMemberVC = SubMemberViewController()
        subMemberVC.viewModel?.orderType = orderType
        subMemberVC.viewModel?.cacheData = viewModel?.cacheData
        subMemberVC.viewModel?.helper = viewModel?.helper
        subMemberVC.parentViewModel = viewModel
        let subTabTag = 3
        subMemberVC.tabBarItem = UITabBarItem(title: "ベンチ", image: UIImage(named: "sub_icon"), tag: subTabTag)
        
        viewControllers = [orderVC, startingMemberListVC, fieldVC, subMemberVC]
    }
    
    private func setRightBarButtonItem() {
        let iconImage = UIImage(named: "setting_icon")
        let rightBarButtonItem = UIBarButtonItem(image: iconImage, style: .plain, target: self, action: #selector(onClickSetting))
        navigationItem.rightBarButtonItem = rightBarButtonItem
    }
    
    @objc private func onClickSetting() {
        let settingVC = SettingViewController()
        navigationController?.pushViewController(settingVC, animated: true)
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
        guard let controllers = self.viewControllers else { return }
        for vc in controllers {
            if let controller: OrderViewController = vc as? OrderViewController {
                controller.reloadOrder()
            }
            if let controller: SubMemberViewController = vc as? SubMemberViewController {
                controller.reloadOrder()
            }
        }
    }
    
    func setUIDefault() {
        guard let controllers = self.viewControllers else { return }
        for vc in controllers {
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
        guard let controllers = self.viewControllers else { return }
        for vc in controllers {
            if let controller: OrderViewController = vc as? OrderViewController {
                try controller.viewModel?.updateStartingTable(db, orderNum: startingNum, newData: startingPlayer)
            }
            if let controller: SubMemberViewController = vc as? SubMemberViewController {
                try controller.viewModel?.updateSubTable(db, newData: subPlayer)
            }
        }
    }
}
