//
//  CustomTabBarViewModel.swift
//  BaseballLineupIOS
//
//  Created by Koro Saka on 2020-12-07.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import UIKit

// MARK: for exchanging starting and sub members
class CustomTabBarViewModel {
    var orderType: OrderType?
    var cacheData: CacheOrderData
    var helper: DatabaseHelper
    
    weak var delegate: CustomTabBarVMDelegate?
    
    var isExchangingStartingSub = false
    var subIndexToExchange: Int?
    var startingOrderNumToExchange: OrderNum?
    
    init() {
        cacheData = .init()
        helper = .init()
    }
    
    
    func selectSubButton(index: Int) {
        subIndexToExchange = index
    }
    
    func getSubButtonColor(index: Int) -> UIColor {
        guard let selectedIndex = subIndexToExchange else {
            return .systemBlue
        }
        if index == selectedIndex {
            return .red
        } else {
            return .systemBlue
        }
    }
    
    func switchScreen(screenIndex: Int) {
        delegate?.switchScreen(screenIndex)
    }
}

protocol CustomTabBarVMDelegate: class {
    func switchScreen(_ screenIndex: Int)
}
