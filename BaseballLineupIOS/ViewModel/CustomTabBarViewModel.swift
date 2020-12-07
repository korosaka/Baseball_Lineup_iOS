//
//  CustomTabBarViewModel.swift
//  BaseballLineupIOS
//
//  Created by Koro Saka on 2020-12-07.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import Foundation

// MARK: for exchanging starting and sub members
class CustomTabBarViewModel {
    var orderType: OrderType?
    var cacheData: CacheOrderData
    var helper: DatabaseHelper
    
    init() {
        cacheData = .init()
        helper = .init()
    }
}
