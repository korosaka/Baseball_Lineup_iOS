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
    
    private var playersInfo = [PlayerInfoForField]()
    
    private func clearData() {
        for index in 0..<playersInfo.count {
            playersInfo[index] = createEmptyPlayer()
        }
    }
    
    func setup() {
        playersInfo.removeAll() //to avoid unexpected bugs
        var maxPlayerNum = 0
        switch orderType {
        case .Normal:
            maxPlayerNum = 9
        case .DH:
            maxPlayerNum = 10
        case .Special:
            maxPlayerNum = 15
        case nil:
            break
        }
        for _ in 0..<maxPlayerNum {
            playersInfo.append(createEmptyPlayer())
        }
    }
    
    func loadOrderInfo() {
        clearData()
        guard let _orderType = orderType,
              let _cacheData = cacheData
        else { return }
        //TODO: fix for All Hitter
        let playerNum = _orderType == .DH ? 10 : 9
        let cachedPlayersInfo = _cacheData.getStartingOrder(orderType: _orderType)
        
        for order in 1...playerNum {
            let orderNum = OrderNum(order: order)
            let player = cachedPlayersInfo[orderNum.index]
            switch player.position {
            case .Non:
                print("do nothing")
            case .Pitcher:
                let pitcherFieldIndex = 0
                if _orderType == .DH {
                    playersInfo[pitcherFieldIndex].orderNum = Constants.DH_PITCHER_NUM
                } else {
                    playersInfo[pitcherFieldIndex].orderNum = orderNum.forFieldDisplay
                }
                playersInfo[pitcherFieldIndex].playerName = player.name.forDisplay
            //MARK: TODO when implementing ALL HITTER, the code must be fixed
            default:
                if player.position.index < 1 { return }
                //MARK: this index is different from Position.index (shifting by 1 for some reasons...)
                let positionFieldIndex = player.position.index - 1
                playersInfo[positionFieldIndex].orderNum = orderNum.forFieldDisplay
                playersInfo[positionFieldIndex].playerName = player.name.forDisplay
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
        return playersInfo[positionFieldIndex].playerName
    }
    
    func getOrderNum(_ positionFieldIndex: Int) -> String {
        return playersInfo[positionFieldIndex].orderNum
    }
    
    func getPlayersCount() -> Int {
        return playersInfo.count
    }
    
    private struct PlayerInfoForField {
        var orderNum: String
        var playerName: String
    }
    
    private func createEmptyPlayer() -> PlayerInfoForField {
        return PlayerInfoForField(orderNum: Constants.NO_NUM_FOR_FIELD,
                                  playerName: Constants.NOT_REGISTERED)
    }
}
