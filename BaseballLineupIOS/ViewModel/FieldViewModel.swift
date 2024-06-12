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
    
    private func clearData() {
        for i in 0..<playersInField.count {
            playersInField[i] = createEmptyPlayer()
        }
    }
    
    func setup() {
        playersInField.removeAll() //to avoid unexpected bugs
        var maxPlayersCount = 0
        switch orderType {
        case .Normal:
            maxPlayersCount = PositionInField.Right.count
        case .DH:
            maxPlayersCount = PositionInField.DH1.count
        case .Special:
            maxPlayersCount = PositionInField.DH6.count
        case nil:
            break
        }
        for _ in 0..<maxPlayersCount {
            playersInField.append(createEmptyPlayer())
        }
    }
    
    func loadOrderInfo() {
        clearData()
        guard let _orderType = orderType,
              let _cacheData = cacheData
        else { return }
        
        let cachedPlayersInfo = _cacheData.getStartingOrder(orderType: _orderType)
        let firstHitterOrder = 1
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
                //MARK: TODO when implementing ALL HITTER, the code must be fixed
            default:
                if cachedPlayerInfo.position.index < Position.Pitcher.index { return }
                ///This index is different from Position.index (shifting by 1 for because there is "No-Pisition" in Position, but not in PositionInField)
                let positionFieldIndex = cachedPlayerInfo.position.index - 1
                playersInField[positionFieldIndex].orderNum = orderNum.forFieldDisplay
                playersInField[positionFieldIndex].playerName = cachedPlayerInfo.name.forDisplay
            }
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
