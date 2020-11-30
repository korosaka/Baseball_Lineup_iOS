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
    let indexDHP = 9
    
    func fetchOrderFromDB(_ orderType: OrderType, _ helper: DatabaseHelper) {
        let result = helper.inDatabase{(db) in
            switch orderType {
            case .Normal:
                startingOrderNormal.removeAll()
                for order in 1...9 {
                    let playerNormal = try StartingNormalTable.fetchOne(db, key: order)
                    if playerNormal != nil {
                        let startingPlayer = StartingPlayer(order: OrderNum(order: order),
                                                            position: Position(description: playerNormal!.position),
                                                            name: PlayerName(original: playerNormal!.name))
                        startingOrderNormal.append(startingPlayer)
                    } else {
                        let emptyPlayer = StartingPlayer(order: OrderNum(order: order),
                                                         position: Position.Non,
                                                         name: PlayerName(original: Constants.EMPTY))
                        startingOrderNormal.append(emptyPlayer)
                    }
                }
            case .DH:
                startingOrderDH.removeAll()
                for order in 1...10 {
                    let playerDH = try StartingDHTable.fetchOne(db, key: order)
                    if playerDH != nil {
                        let startingPlayer = StartingPlayer(order: OrderNum(order: order),
                                                            position: Position(description: playerDH!.position),
                                                            name: PlayerName(original: playerDH!.name))
                        startingOrderDH.append(startingPlayer)
                    } else {
                        let emptyPlayer = StartingPlayer(order: OrderNum(order: order),
                                                         position: Position.Non,
                                                         name: PlayerName(original: Constants.EMPTY))
                        startingOrderDH.append(emptyPlayer)
                    }
                }
            }
        }
        if !result {
            print("Error happened !!! (setOrderFromDB)")
        }
    }
    
    // MARK: be careful, because in Swift, Array is value type,,,,
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
    
    func exchangeOrder(orderType: OrderType ,num1: OrderNum, num2: OrderNum) {
        switch orderType {
        case .DH:
            if num1.index == indexDHP {
                exchange2PlayersWithDHPitcher(fielderNum: num2)
            } else if num2.index == indexDHP {
                exchange2PlayersWithDHPitcher(fielderNum: num1)
            } else {
                exchange2Players(order: &startingOrderDH, num1, num2)
            }
        default:
            exchange2Players(order: &startingOrderNormal, num1, num2)
        }
    }
    
    func exchange2Players(order: inout [StartingPlayer], _ num1: OrderNum, _ num2: OrderNum) {
        
        // MARK: TODO
        order[num1.index].order = num2
        order[num2.index].order = num1
        
        let tmp = order[num1.index]
        order[num1.index] = order[num2.index]
        order[num2.index] = tmp
    }
    
    func exchange2PlayersWithDHPitcher(fielderNum: OrderNum) {
        let tmp = startingOrderDH[indexDHP].name
        startingOrderDH[indexDHP].name = startingOrderDH[fielderNum.index].name
        startingOrderDH[fielderNum.index].name = tmp
    }
}
