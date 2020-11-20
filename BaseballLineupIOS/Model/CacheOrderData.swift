//
//  CacheOrderData.swift
//  BaseballLineupIOS
//
//  Created by Koro Saka on 2020-11-17.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import Foundation
struct StartingPlayer {
    var order: OrderNum
    var position: Position
    var name: String
}

struct OrderNum {
    var order: Int
    var index: Int {
        return order - 1
    }
}

enum OrderType {
    case Normal, DH
}

enum Position {
    case Non, Pitcher, Catcher, First, Second, Third, Short, Left, Center, Right, DH
    
    init(description: String) {
        switch description {
        case Constants.positions[1]:
            self = .Pitcher
        case Constants.positions[2]:
            self = .Catcher
        case Constants.positions[3]:
            self = .First
        case Constants.positions[4]:
            self = .Second
        case Constants.positions[5]:
            self = .Third
        case Constants.positions[6]:
            self = .Short
        case Constants.positions[7]:
            self = .Left
        case Constants.positions[8]:
            self = .Center
        case Constants.positions[9]:
            self = .Right
        case Constants.positions[10]:
            self = .DH
        default:
            self = .Non
        }
    }
    
    var description: String {
        switch self {
        case .Pitcher:
            return Constants.positions[1]
        case .Catcher:
            return Constants.positions[2]
        case .First:
            return Constants.positions[3]
        case .Second:
            return Constants.positions[4]
        case .Third:
            return Constants.positions[5]
        case .Short:
            return Constants.positions[6]
        case .Left:
            return Constants.positions[7]
        case .Center:
            return Constants.positions[8]
        case .Right:
            return Constants.positions[9]
        case .DH:
            return Constants.positions[10]
        default:
            return Constants.positions[0]
        }
    }
}

class CacheOrderData {
    var startingOrderNormal = [StartingPlayer]()
    var startingOrderDH = [StartingPlayer]()
    
    init() {
        setEmptyData()
    }
    
    func setEmptyData() {
        for num in 1...9 {
            let emptyPlayer = StartingPlayer(order: OrderNum(order: num), position: Position.Non, name: "----")
            startingOrderNormal.append(emptyPlayer)
        }
        
        for num in 1...10 {
            let emptyPlayer = StartingPlayer(order: OrderNum(order: num), position: Position.Non, name: "----")
            startingOrderDH.append(emptyPlayer)
        }
    }
    
    func getOrder(orderType: OrderType) -> [StartingPlayer] {
        switch orderType {
        case .DH:
            return startingOrderDH
        default:
            return startingOrderNormal
        }
    }
    
    func overWriteStartingPlayer(type: OrderType, player: StartingPlayer) {
        switch type {
        case .DH:
            startingOrderDH[player.order.index] = player
        default:
            startingOrderNormal[player.order.index] = player
        }
    }
}
