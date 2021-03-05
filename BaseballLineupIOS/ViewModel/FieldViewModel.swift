//
//  FieldViewModel.swift
//  BaseballLineupIOS
//
//  Created by Koro Saka on 2020-12-07.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import Foundation

class FieldViewModel {
    var orderType: OrderType?
    var cacheData: CacheOrderData?
    
    func getStartingOrder() -> [StartingPlayer]? {
        guard let _orderType = orderType,
              let _cacheData = cacheData
        else { return nil }
        
        return _cacheData.getStartingOrder(orderType: _orderType)
    }
}
