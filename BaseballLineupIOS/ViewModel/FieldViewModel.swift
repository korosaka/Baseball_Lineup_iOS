//
//  FieldViewModel.swift
//  BaseballLineupIOS
//
//  Created by Koro Saka on 2020-12-07.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import Foundation
import UIKit

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
    
    func getNameLabelColor(_ index: Int) -> UIColor {
        switch index {
        case 0:
            return UIColor.pitcherColor
        case 1:
            return UIColor.catcherColor
        case 2...5:
            return UIColor.infielderColor
        case 6...8:
            return UIColor.outfielderColor
        default:
            return UIColor.dhColor
        }
    }
    
    func getPlayerName(_ index: Int) -> String {
        switch index {
        case 0:
            return pitcherName
        case 1:
            return catcherName
        case 2:
            return firstName
        case 3:
            return secondName
        case 4:
            return thirdName
        case 5:
            return shortName
        case 6:
            return leftName
        case 7:
            return centerName
        case 8:
            return rightName
        default:
            return dh1Name
        }
    }
    
    func getOrderNum(_ index: Int) -> String {
        switch index {
        case 0:
            return pitcherNum
        case 1:
            return catcherNum
        case 2:
            return firstNum
        case 3:
            return secondNum
        case 4:
            return thirdNum
        case 5:
            return shortNum
        case 6:
            return leftNum
        case 7:
            return centerNum
        case 8:
            return rightNum
        default:
            return dh1Num
        }
    }
}
