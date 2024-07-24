//
//  StartingMemberListViewModel.swift
//  BaseballLineupIOS
//
//  Created by 坂公郎 on 2024/07/23.
//  Copyright © 2024 Koro Saka. All rights reserved.
//

import Foundation
class StartingMemberListViewModel {
    var orderType: OrderType?
    var cacheData: CacheOrderData?
    
    private func getStatingOrder() -> [StartingPlayer] {
        guard let _cacheData = cacheData, let _orderType = orderType else { return [] }
        return _cacheData.getStartingOrder(orderType: _orderType)
    }
    
    func getStatingPlayer(num: OrderNum) -> StartingPlayer {
        return getStatingOrder()[num.index]
    }
    
    func getOrdeSize() -> Int {
        guard let _orderType = orderType else { return 0 }
        switch _orderType {
        case .Normal:
            return cacheData?.startingOrderNormal.count ?? 0
        case .DH:
            return cacheData?.startingOrderDH.count ?? 0
        case .Special:
            return cacheData?.startingOrderSpecial.count ?? 0
        }
    }
    
    func getNumText(orderNum: OrderNum) -> String {
        if isDHPitcher(orderNum: orderNum) {
            return "P"
        } else {
            return "\(orderNum.order)番"
        }
    }
    
    private func isDHPitcher(orderNum: OrderNum) -> Bool {
        return (orderNum.order == Constants.SUPPOSED_DHP_ORDER) && (orderType == .DH)
    }
}
