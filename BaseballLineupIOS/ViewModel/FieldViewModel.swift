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
    enum PositionInField {
        case Pitcher, Catcher, First, Second, Third, Short, Left, Center, Right, DH1, DH2, DH3, DH4, DH5, DH6
        
        var index: Int {
            switch self {
            case .Pitcher:
                return 0
            case .Catcher:
                return 1
            case .First:
                return 2
            case .Second:
                return 3
            case .Third:
                return 4
            case .Short:
                return 5
            case .Left:
                return 6
            case .Center:
                return 7
            case .Right:
                return 8
            case .DH1:
                return 9
            case .DH2:
                return 10
            case .DH3:
                return 11
            case .DH4:
                return 12
            case .DH5:
                return 13
            case .DH6:
                return 14
            }
        }
        
        var count: Int {
            return self.index + 1
        }
    }
    
    var orderType: OrderType?
    var cacheData: CacheOrderData?
    
    private var playersInField = [PlayerInfoForField]()
    
    func loadOrderInfo() {
        guard let _orderType = orderType,
              let _cacheData = cacheData
        else { return }
        
        let cachedPlayersInfo = _cacheData.getStartingOrder(orderType: _orderType)
        
        appendEmptyPlayers(cachedPlayersInfo.count)
        
        var dhCounter = 0
        let firstHitterOrder = 1
        if cachedPlayersInfo.count < Constants.MIN_PLAYERS_NUMBER_SPECIAL { return } //to avoid unexpected bugs
        for order in firstHitterOrder...cachedPlayersInfo.count {
            let orderNum = OrderNum(order: order)
            let cachedPlayerInfo = cachedPlayersInfo[orderNum.index]
            switch cachedPlayerInfo.position {
            case .Non:
                print("do nothing")
            case .Pitcher:
                if _orderType == .DH {
                    playersInField[PositionInField.Pitcher.index].orderNum = Constants.DH_PITCHER_NUM
                } else {
                    playersInField[PositionInField.Pitcher.index].orderNum = orderNum.forFieldDisplay
                }
                playersInField[PositionInField.Pitcher.index].playerName = cachedPlayerInfo.name.forDisplay
            case .DH:
                let isNonDHCase = playersInField.count < Constants.PLAYERS_NUMBER_DH
                if isNonDHCase { continue }
                
                var index = PositionInField.DH1.index + dhCounter
                dhCounter += 1
                
                //when more DH hitters are registered than DH positions
                if index >= playersInField.count {
                    let lastDHIndex = playersInField.count - 1
                    index = lastDHIndex
                }
                
                playersInField[index].orderNum = orderNum.forFieldDisplay
                playersInField[index].playerName = cachedPlayerInfo.name.forDisplay
            default:
                if cachedPlayerInfo.position.indexForOrder < Position.Pitcher.indexForOrder { return }
                ///This index is different from Position.index (shifting by 1 for because there is "No-Pisition" in Position, but not in PositionInField)
                let positionFieldIndex = cachedPlayerInfo.position.indexForOrder - 1
                playersInField[positionFieldIndex].orderNum = orderNum.forFieldDisplay
                playersInField[positionFieldIndex].playerName = cachedPlayerInfo.name.forDisplay
            }
        }
    }
    
    private func appendEmptyPlayers(_ playersCount: Int) {
        playersInField.removeAll()
        for _ in 0..<playersCount {
            playersInField.append(createEmptyPlayer())
        }
    }
    
    func getNameLabelColor(_ index: Int) -> UIColor {
        switch index {
        case PositionInField.Pitcher.index:
            return UIColor.pitcherColor
        case PositionInField.Catcher.index:
            return UIColor.catcherColor
        case PositionInField.First.index...PositionInField.Short.index:
            return UIColor.infielderColor
        case PositionInField.Left.index...PositionInField.Right.index:
            return UIColor.outfielderColor
        default:
            return UIColor.dhColor
        }
    }
    
    func getNameBorderColor(_ index: Int) -> UIColor {
        switch index {
        case PositionInField.Pitcher.index:
            return UIColor.pitcherBorderColor
        case PositionInField.Catcher.index:
            return UIColor.catcherBorderColor
        case PositionInField.First.index...PositionInField.Short.index:
            return UIColor.infielderBorderColor
        case PositionInField.Left.index...PositionInField.Right.index:
            return UIColor.outfielderBorderColor
        default:
            return UIColor.dhBorderColor
        }
    }
    
    func getPlayerName(_ positionFieldIndex: Int) -> String {
        return playersInField[positionFieldIndex].playerName
    }
    
    func getOrderNum(_ positionFieldIndex: Int) -> String {
        return playersInField[positionFieldIndex].orderNum
    }
    
    func getPlayersCount() -> Int {
        return playersInField.count
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
