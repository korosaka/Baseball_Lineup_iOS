//
//  SubMemberViewModel.swift
//  BaseballLineupIOS
//
//  Created by Koro Saka on 2020-12-07.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import Foundation

class SubMemberViewModel {
    var orderType: OrderType?
    var cacheData: CacheOrderData?
    var helper: DatabaseHelper?
    
    func getOrdeSize() -> Int {
        return cacheData?.getSubOrder(orderType: orderType!).count ?? 0
    }
    
    func addNumOfSub() {
        cacheData?.addSubPlayer(type: orderType!,
                                player: createEmptyPlayer())
        
    }
    
    func createEmptyPlayer() -> SubPlayer {
        return SubPlayer(id: UUID().uuidString,
                         name: PlayerName(original: Constants.EMPTY),
                         isPitcher: 0,
                         isHitter: 0,
                         isRunner: 0,
                         isFielder: 0)
    }
}
