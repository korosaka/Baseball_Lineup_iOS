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
    
    var pitcherNum = Constants.NO_NUM_FOR_FIELD
    var catcherNum = Constants.NO_NUM_FOR_FIELD
    var firstNum = Constants.NO_NUM_FOR_FIELD
    var secondNum = Constants.NO_NUM_FOR_FIELD
    var thirdNum = Constants.NO_NUM_FOR_FIELD
    var shortNum = Constants.NO_NUM_FOR_FIELD
    var leftNum = Constants.NO_NUM_FOR_FIELD
    var centerNum = Constants.NO_NUM_FOR_FIELD
    var rightNum = Constants.NO_NUM_FOR_FIELD
    var dh1Num = Constants.NO_NUM_FOR_FIELD
    
    var pitcherName = Constants.NOT_REGISTERED
    var catcherName = Constants.NOT_REGISTERED
    var firstName = Constants.NOT_REGISTERED
    var secondName = Constants.NOT_REGISTERED
    var thirdName = Constants.NOT_REGISTERED
    var shortName = Constants.NOT_REGISTERED
    var leftName = Constants.NOT_REGISTERED
    var centerName = Constants.NOT_REGISTERED
    var rightName = Constants.NOT_REGISTERED
    var dh1Name = Constants.NOT_REGISTERED
    
    func loadOrderInfo() {
        guard let _orderType = orderType,
              let _cacheData = cacheData
        else { return }
        
        let playerNum = _orderType == .DH ? 10 : 9
        let playersInfo = _cacheData.getStartingOrder(orderType: _orderType)
        
        for order in 1...playerNum {
            let orderNum = OrderNum(order: order)
            let player = playersInfo[orderNum.index]
            switch player.position {
            case .Pitcher:
                if _orderType == .DH {
                    pitcherNum = Constants.DH_PITCHER_NUM
                } else {
                    pitcherNum = orderNum.forFieldDisplay
                }
                pitcherName = player.name.forDisplay
            case .Catcher:
                catcherNum = orderNum.forFieldDisplay
                catcherName = player.name.forDisplay
            case .First:
                firstNum = orderNum.forFieldDisplay
                firstName = player.name.forDisplay
            case .Second:
                secondNum = orderNum.forFieldDisplay
                secondName = player.name.forDisplay
            case .Third:
                thirdNum = orderNum.forFieldDisplay
                thirdName = player.name.forDisplay
            case .Short:
                shortNum = orderNum.forFieldDisplay
                shortName = player.name.forDisplay
            case .Left:
                leftNum = orderNum.forFieldDisplay
                leftName = player.name.forDisplay
            case .Center:
                centerNum = orderNum.forFieldDisplay
                centerName = player.name.forDisplay
            case .Right:
                rightNum = orderNum.forFieldDisplay
                rightName = player.name.forDisplay
            case .DH:
                dh1Num = orderNum.forFieldDisplay
                dh1Name = player.name.forDisplay
            default:
                print("do nothing")
            }
        }
    }
}
