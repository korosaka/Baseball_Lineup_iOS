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
    
    private var orderNums = [String]()
    private var playerNames = [String]()
    
    init() {
        let maxPlayerNum = 10
        for _ in 0..<maxPlayerNum {
            orderNums.append(Constants.NO_NUM_FOR_FIELD)
            playerNames.append(Constants.NOT_REGISTERED)
        }
    }
    private func clearData() {
        for index in 0..<orderNums.count {
            orderNums[index] = Constants.NO_NUM_FOR_FIELD
        }
        for index in 0..<playerNames.count {
            playerNames[index] = Constants.NOT_REGISTERED
        }
    }
    
    func loadOrderInfo() {
        clearData()
        guard let _orderType = orderType,
              let _cacheData = cacheData
        else { return }
        
        let playerNum = _orderType == .DH ? 10 : 9
        let playersInfo = _cacheData.getStartingOrder(orderType: _orderType)
        
        for order in 1...playerNum {
            let orderNum = OrderNum(order: order)
            let player = playersInfo[orderNum.index]
            switch player.position {
            case .Non:
                print("do nothing")
            case .Pitcher:
                let pitcherFieldIndex = 0
                if _orderType == .DH {
                    orderNums[pitcherFieldIndex] = Constants.DH_PITCHER_NUM
                } else {
                    orderNums[pitcherFieldIndex] = orderNum.forFieldDisplay
                }
                playerNames[pitcherFieldIndex] = player.name.forDisplay
            //MARK: TODO when implementing ALL HITTER, the code must be fixed
            default:
                if player.position.index < 1 { return }
                //MARK: this index is different from Position.index (shifting by 1 for some reasons...)
                let positionFieldIndex = player.position.index - 1
                orderNums[positionFieldIndex] = orderNum.forFieldDisplay
                playerNames[positionFieldIndex] = player.name.forDisplay
                
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
    
    func getPlayerName(_ positionFieldIndex: Int) -> String {
        return playerNames[positionFieldIndex]
    }
    
    func getOrderNum(_ positionFieldIndex: Int) -> String {
        return orderNums[positionFieldIndex]
    }
}
