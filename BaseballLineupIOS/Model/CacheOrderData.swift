//
//  CacheOrderData.swift
//  BaseballLineupIOS
//
//  Created by Koro Saka on 2020-11-17.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import Foundation
struct StartingPlayer {
    var orderNum: Int
    var position: String
    var name: String
}

enum OrderType {
    case Normal, DH
}


class CacheOrderData {
    var startingOrderNormal = [StartingPlayer]()
    var startingOrderDH = [StartingPlayer]()
    
    init() {
        setEmptyData()
    }
    
    func setEmptyData() {
        for num in 1...9 {
            let emptyPlayer = StartingPlayer(orderNum: num, position: "---", name: "----")
            startingOrderNormal.append(emptyPlayer)
        }
        
        for num in 1...10 {
            let emptyPlayer = StartingPlayer(orderNum: num, position: "---", name: "----")
            startingOrderDH.append(emptyPlayer)
        }
    }
    
    func getOrder(orderType: OrderType) -> [StartingPlayer] {
        switch orderType {
        case .Normal:
            return startingOrderNormal
        default:
            return startingOrderDH
        }
    }
}
