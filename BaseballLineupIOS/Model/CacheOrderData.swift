//
//  CacheOrderData.swift
//  BaseballLineupIOS
//
//  Created by Koro Saka on 2020-11-17.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import Foundation
struct StartingPlayer {
    var position: Position
    var name: PlayerName
    
    init(position: Position = Position.Non,
         name: PlayerName = PlayerName()) {
        self.position = position
        self.name = name
    }
}

struct SubPlayer {
    let id: String
    var name: PlayerName
    var isPitcher: Int
    var isHitter: Int
    var isRunner: Int
    var isFielder: Int
}

// MARK: in SQLite, there is not Bool type
extension Int {
    func convertToBool() -> Bool {
        if self == 1 {
            return true
        }
        return false
    }
}

extension Bool {
    func convertToInt() -> Int {
        if self == true {
            return 1
        }
        return 0
    }
}

struct OrderNum {
    var order: Int
    var index: Int {
        return order - 1
    }
    var forFieldDisplay: String {
        return "\(order)"
    }
}

enum OrderType {
    case Normal, DH, Special
}

// MARK: should use extention String,,,,,?
struct PlayerName {
    var original: String
    var forDisplay: String {
        let space = Character(Constants.SPACE)
        let array = Array(original)
        if original == Constants.EMPTY {
            return Constants.NOT_REGISTERED
        } else if original.count == 2 {
            return String([array[0], space, space, array[1]])
        } else if original.count == 3 {
            return String([array[0], space, array[1], space, array[2]])
        } else {
            return original
        }
    }
    
    init(original: String = Constants.EMPTY) {
        self.original = original
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
        return Constants.POSITIONS[indexForOrder]
    }
    
    var indexForOrder: Int {
        switch self {
        case .Non:
            return 0
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
        }
    }
}

class CacheOrderData {
    var startingOrderNormal = [StartingPlayer]()
    var startingOrderDH = [StartingPlayer]()
    var startingOrderSpecial = [StartingPlayer]()
    var subOrderNormal = [SubPlayer]()
    var subOrderDH = [SubPlayer]()
    var subOrderSpecial = [SubPlayer]()
    let indexForDHP = Constants.SUPPOSED_DHP_ORDER - 1
    //
    func fetchOrderFromDB(_ orderType: OrderType, _ helper: DatabaseHelper) {
        let result = helper.inDatabase{(db) in
            switch orderType {
            case .Normal:
                startingOrderNormal.removeAll()
                for order in Constants.ORDER_FIRST...Constants.PLAYERS_NUMBER_NORMAL {
                    let playerNormal = try StartingNormalTable.fetchOne(db, key: order)
                    guard let _playerNormal = playerNormal else {
                        //TODO: it looks needless because empty data shuld have been added to Table for each order when DB table is created
                        startingOrderNormal.append(StartingPlayer())
                        continue
                    }
                    let startingPlayer = StartingPlayer(position: Position(description: _playerNormal.position),
                                                        name: PlayerName(original: _playerNormal.name))
                    startingOrderNormal.append(startingPlayer)
                }
                
                subOrderNormal.removeAll()
                var resultsSub: [SubNormalTable] = []
                resultsSub = try SubNormalTable.fetchAll(db)
                resultsSub.forEach { (resultSub) in
                    let subPlayer = SubPlayer(id: resultSub.id,
                                              name: PlayerName(original: resultSub.name),
                                              isPitcher: resultSub.is_pitcher,
                                              isHitter: resultSub.is_hitter,
                                              isRunner: resultSub.is_runner,
                                              isFielder: resultSub.is_fielder)
                    subOrderNormal.append(subPlayer)
                }
                
            case .DH:
                startingOrderDH.removeAll()
                for order in Constants.ORDER_FIRST...Constants.PLAYERS_NUMBER_DH {
                    let playerDH = try StartingDHTable.fetchOne(db, key: order)
                    guard let _playerDH = playerDH else {
                        //TODO: it looks needless because empty data shuld have been added to Table for each order when DB table is created
                        startingOrderDH.append(StartingPlayer())
                        continue
                    }
                    let startingPlayer = StartingPlayer(position: Position(description: _playerDH.position),
                                                        name: PlayerName(original: _playerDH.name))
                    startingOrderDH.append(startingPlayer)
                }
                
                subOrderDH.removeAll()
                var resultsSub: [SubDHTable] = []
                resultsSub = try SubDHTable.fetchAll(db)
                resultsSub.forEach { (resultSub) in
                    let subPlayer = SubPlayer(id: resultSub.id,
                                              name: PlayerName(original: resultSub.name),
                                              isPitcher: resultSub.is_pitcher,
                                              isHitter: resultSub.is_hitter,
                                              isRunner: resultSub.is_runner,
                                              isFielder: resultSub.is_fielder)
                    subOrderDH.append(subPlayer)
                }
            case .Special:
                startingOrderSpecial.removeAll()
                for order in Constants.ORDER_FIRST...Constants.MAX_PLAYERS_NUMBER_SPECIAL {
                    do {
                        let playerSpecial = try StartingSpecialTable.fetchOne(db, key: order)
                        guard let player = playerSpecial else { break }
                        let startingPlayer = StartingPlayer(position: Position(description: player.position),
                                                            name: PlayerName(original: player.name))
                        startingOrderSpecial.append(startingPlayer)
                    } catch _ {
                        break
                    }
                }
                
                subOrderSpecial.removeAll()
                var resultsSub: [SubSpecialTable] = []
                resultsSub = try SubSpecialTable.fetchAll(db)
                resultsSub.forEach { (resultSub) in
                    let subPlayer = SubPlayer(id: resultSub.id,
                                              name: PlayerName(original: resultSub.name),
                                              isPitcher: resultSub.is_pitcher,
                                              isHitter: resultSub.is_hitter,
                                              isRunner: resultSub.is_runner,
                                              isFielder: resultSub.is_fielder)
                    subOrderSpecial.append(subPlayer)
                }
            }
        }
        if !result {
            print("Error happened !!! (setOrderFromDB)")
        }
    }
    
    // MARK: be careful, because in Swift, Array is value type,,,,
    func getStartingOrder(orderType: OrderType) -> [StartingPlayer] {
        switch orderType {
        case .DH:
            return startingOrderDH
        case .Normal:
            return startingOrderNormal
        case .Special:
            return startingOrderSpecial
        }
    }
    
    func getSubOrder(orderType: OrderType) -> [SubPlayer] {
        switch orderType {
        case .DH:
            return subOrderDH
        case .Normal:
            return subOrderNormal
        case .Special:
            return subOrderSpecial
        }
    }
    
    func overWriteStartingPlayer(type: OrderType, orderNum: OrderNum, player: StartingPlayer) {
        switch type {
        case .DH:
            startingOrderDH[orderNum.index] = player
        case .Normal:
            startingOrderNormal[orderNum.index] = player
        case .Special:
            startingOrderSpecial[orderNum.index] = player
        }
    }
    
    func overWriteSubPlayer(type: OrderType, index: Int, player: SubPlayer) {
        switch type {
        case .DH:
            subOrderDH[index] = player
        case .Normal:
            subOrderNormal[index] = player
        case .Special:
            subOrderSpecial[index] = player
        }
    }
    
    func exchangeStartingOrder(orderType: OrderType ,num1: OrderNum, num2: OrderNum) {
        switch orderType {
        case .DH:
            if num1.index == indexForDHP {
                exchangeStartingWithDHP(fielderNum: num2)
            } else if num2.index == indexForDHP {
                exchangeStartingWithDHP(fielderNum: num1)
            } else {
                exchangeStartingWithoutDHP(order: &startingOrderDH, num1, num2)
            }
        case .Normal:
            exchangeStartingWithoutDHP(order: &startingOrderNormal, num1, num2)
        case .Special:
            exchangeStartingWithoutDHP(order: &startingOrderSpecial, num1, num2)
        }
    }
    
    func exchangeStartingWithoutDHP(order: inout [StartingPlayer], _ num1: OrderNum, _ num2: OrderNum) {
        let tmp = order[num1.index]
        order[num1.index] = order[num2.index]
        order[num2.index] = tmp
    }
    
    func exchangeStartingWithDHP(fielderNum: OrderNum) {
        let tmp = startingOrderDH[indexForDHP].name
        startingOrderDH[indexForDHP].name = startingOrderDH[fielderNum.index].name
        startingOrderDH[fielderNum.index].name = tmp
    }
    
    func exchangeSubOrder(orderType: OrderType ,index1: Int, index2: Int) {
        switch orderType {
        case .DH:
            exchangeSubPlayers(order: &subOrderDH, index1, index2)
        case .Normal:
            exchangeSubPlayers(order: &subOrderNormal, index1, index2)
        case .Special:
            exchangeSubPlayers(order: &subOrderSpecial, index1, index2)
        }
    }
    
    func exchangeSubPlayers(order: inout [SubPlayer], _ index1: Int, _ index2: Int) {
        let tmp = order[index1]
        
        //TODO: refactor?
        order[index1].name = order[index2].name
        order[index1].isPitcher = order[index2].isPitcher
        order[index1].isHitter = order[index2].isHitter
        order[index1].isRunner = order[index2].isRunner
        order[index1].isFielder = order[index2].isFielder
        order[index2].name = tmp.name
        order[index2].isPitcher = tmp.isPitcher
        order[index2].isHitter = tmp.isHitter
        order[index2].isRunner = tmp.isRunner
        order[index2].isFielder = tmp.isFielder
    }
    
    func exchangeStartingSubOrder(orderType: OrderType ,startingNum: OrderNum, subIndex: Int) {
        //TODO: refactor?
        switch orderType {
        case .DH:
            exchangeStartingSubPlayers(&startingOrderDH, &subOrderDH, startingNum, subIndex)
        case .Normal:
            exchangeStartingSubPlayers(&startingOrderNormal, &subOrderNormal, startingNum, subIndex)
        case .Special:
            exchangeStartingSubPlayers(&startingOrderSpecial, &subOrderSpecial, startingNum, subIndex)
        }
    }
    
    func exchangeStartingSubPlayers(_ startingOrder: inout [StartingPlayer],
                                    _ subOrder: inout [SubPlayer],
                                    _ startingNum: OrderNum,
                                    _ subIndex: Int) {
        let tmp = startingOrder[startingNum.index]
        startingOrder[startingNum.index].name = subOrder[subIndex].name
        subOrder[subIndex].name = tmp.name
    }
    
    
    func addStartingPlayer(type: OrderType, player: StartingPlayer) {
        guard type == .Special else { return }
        startingOrderSpecial.append(player)
    }
    
    func deleteStartingPlayer(type: OrderType) {
        guard type == .Special else { return }
        startingOrderSpecial.removeLast()
    }
    
    func addSubPlayer(type: OrderType, player: SubPlayer) {
        switch type {
        case .DH:
            subOrderDH.append(player)
        case .Normal:
            subOrderNormal.append(player)
        case .Special:
            subOrderSpecial.append(player)
        }
    }
    
    func removeSubPlayer(type: OrderType, _ index: Int) {
        switch type {
        case .DH:
            subOrderDH.remove(at: index)
        case .Normal:
            subOrderNormal.remove(at: index)
        case .Special:
            subOrderSpecial.remove(at: index)
        }
    }
}
