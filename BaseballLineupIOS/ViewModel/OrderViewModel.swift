//
//  OrderViewModel.swift
//  BaseballLineupIOS
//
//  Created by Koro Saka on 2020-11-11.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import UIKit

class OrderViewModel {
    var orderType: OrderType?
    var cacheData: CacheOrderData
    
    init() {
        cacheData = CacheOrderData()
    }
    
    func getOrdeSize() -> Int {
        switch orderType {
        case .Normal:
            return 9
        case .DH:
            return 10
        default:
            return 0
        }
    }
    
    func getStatingOrder() -> [StartingPlayer] {
        cacheData.getOrder(orderType: orderType!)
    }
    
    func getStatingPlyaer(num: Int) -> StartingPlayer {
        return getStatingOrder()[num]
    }
    
    
}
