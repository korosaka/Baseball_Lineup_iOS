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
    var name: PlayerName
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

struct PlayerName {
    var original: String
    var forDisplay: String {
        if original == Constants.EMPTY {
            return Constants.NOT_REGISTERED
        } else {
            return original
        }
    }
}

enum Position {
    case Non, Pitcher, Catcher, First, Second, Third, Short, Left, Center, Right, DH
    
    init(description: String) {
        switch description {
        case Constants.POSITIONS[1]:
            self = .Pitcher
        case Constants.POSITIONS[2]:
            self = .Catcher
        case Constants.POSITIONS[3]:
            self = .First
        case Constants.POSITIONS[4]:
            self = .Second
        case Constants.POSITIONS[5]:
            self = .Third
        case Constants.POSITIONS[6]:
            self = .Short
        case Constants.POSITIONS[7]:
            self = .Left
        case Constants.POSITIONS[8]:
            self = .Center
        case Constants.POSITIONS[9]:
            self = .Right
        case Constants.POSITIONS[10]:
            self = .DH
        default:
            self = .Non
        }
    }
    
    var description: String {
        return Constants.POSITIONS[index]
    }
    
    var index: Int {
        switch self {
        case .Pitcher:
            return 1
        case .Catcher:
            return 2
        case .First:
            return 3
        case .Second:
            return 4
        case .Third:
            return 5
        case .Short:
            return 6
        case .Left:
            return 7
        case .Center:
            return 8
        case .Right:
            return 9
        case .DH:
            return 10
        default:
            return 0
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
            let emptyPlayer = StartingPlayer(order: OrderNum(order: num),
                                             position: Position.Non,
                                             name: PlayerName(original: Constants.EMPTY))
            startingOrderNormal.append(emptyPlayer)
        }
        
        for num in 1...10 {
            let emptyPlayer = StartingPlayer(order: OrderNum(order: num),
                                             position: Position.Non,
                                             name: PlayerName(original: Constants.EMPTY))
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
