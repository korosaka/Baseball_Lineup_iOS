//
//  OrderViewModel.swift
//  BaseballLineupIOS
//
//  Created by Koro Saka on 2020-11-11.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import UIKit
import GRDB

class OrderViewModel {
    var orderType: OrderType?
    var cacheData: CacheOrderData?
    var helper: DatabaseHelper?
    var selectedPosition = Position.Non
    var writtenName = Constants.EMPTY
    
    weak var delegate: OrderVMDelegate?
    
    var isExchanging = false
    // MARK: this 2 num should be tupple?
    var firstSelectedNum: OrderNum?
    var secondSelectedNum: OrderNum?
    
    var targetOrderNum = OrderNum(order: 0)
    
    func getOrdeSize() -> Int {
        guard let _orderType = orderType else { return 0 }
        switch _orderType {
        case .Normal:
            return cacheData?.startingOrderNormal.count ?? 0
        case .DH:
            return cacheData?.startingOrderDH.count ?? 0
        case .Special:
            return cacheData?.startingOrderSpecial.count ?? 0
        }
    }
    
    func getStatingOrder() -> [StartingPlayer] {
        cacheData!.getStartingOrder(orderType: orderType!)
    }
    
    func getStatingPlayer(num: OrderNum) -> StartingPlayer {
        return getStatingOrder()[num.index]
    }
    
    func selectPlayer(selectedNum: OrderNum) {
        if isExchanging {
            if firstSelectedNum == nil {
                firstSelectedNum = selectedNum
            } else if firstSelectedNum?.order == selectedNum.order {
                firstSelectedNum = nil
            } else {
                secondSelectedNum = selectedNum
                exchangeStartingPlayers()
            }
        } else {
            targetOrderNum = selectedNum
            delegate?.prepareRegistering(selectedNum: selectedNum)
        }
    }
    
    func exchangeStartingPlayers() {
        cacheData!.exchangeStartingOrder(orderType: orderType!, num1: firstSelectedNum!, num2: secondSelectedNum!)
        
        let result = helper!.inDatabase{(db) in
            let player1 = cacheData!.getStartingOrder(orderType: orderType!)[firstSelectedNum!.index]
            let player2 = cacheData!.getStartingOrder(orderType: orderType!)[secondSelectedNum!.index]
            try updateStartingTable(db, orderNum: firstSelectedNum!, newData: player1)
            try updateStartingTable(db, orderNum: secondSelectedNum!, newData: player2)
        }
        if !result {
            print("DB Error happened!!!!!!!!")
        }
        
        resetData()
        delegate?.reloadOrder()
        delegate?.setUIDefault()
    }
    
    func addOrder() {
        //TODO: DB
        guard let _orderType = orderType,
              let playersCount = cacheData?.getStartingOrder(orderType: _orderType).count,
              playersCount < Constants.MAX_PLAYERS_NUMBER_SPECIAL else { return }
        let emptyPlayer = StartingPlayer(position: Position.Non,
                                         name: PlayerName(original: Constants.EMPTY))
        cacheData?.addStartingPlayer(type: _orderType, player: emptyPlayer)
    }
    
    func deleteOrder() {
        //TODO: DB
        guard let _orderType = orderType,
              let playersCount = cacheData?.getStartingOrder(orderType: _orderType).count,
              playersCount > Constants.MIN_PLAYERS_NUMBER_SPECIAL else { return }
        cacheData?.deleteStartingPlayer(type: _orderType)
    }
    
    func shouldRemoveDH() -> Bool {
        guard let _orderType = orderType, _orderType == .Special,
              let players = cacheData?.getStartingOrder(orderType: _orderType) else { return false }
        return players.count < Constants.PLAYERS_NUMBER_DH
    }
    
    func shouldAddDH() -> Bool {
        guard let _orderType = orderType, _orderType == .Special,
              let players = cacheData?.getStartingOrder(orderType: _orderType) else { return false }
        return players.count == Constants.PLAYERS_NUMBER_DH
    }
    
    func getPickerNum() -> Int {
        guard let _orderType = orderType else { return 0 }
        let excludeDH = Position.Right.indexForOrder + 1
        let includeDH = Position.DH.indexForOrder + 1
        
        switch _orderType {
        case .Normal:
            return excludeDH
        case .DH:
            return includeDH
        case .Special:
            guard let playersNum =
                    cacheData?.getStartingOrder(orderType: _orderType).count else { return 0 }
            if playersNum > Constants.MIN_PLAYERS_NUMBER_SPECIAL {
                return includeDH
            } else {
                return excludeDH
            }
        }
    }
    
    func fetchData() {
        //TODO: don't use forced unwrapping
        cacheData!.fetchOrderFromDB(orderType!, helper!)
    }
    
    func overWriteStatingPlayer() {
        guard let _helper = helper,
              let _cacheData = cacheData,
              let _orderType = orderType else { return }
        
        let newPlayer = StartingPlayer(position: selectedPosition,
                                       name: PlayerName(original: writtenName))
        
        let result = _helper.inDatabase{(db) in
            try updateStartingTable(db, orderNum: targetOrderNum, newData: newPlayer)
        }
        
        if result {
            _cacheData.overWriteStartingPlayer(type: _orderType,
                                               orderNum: targetOrderNum,
                                               player: newPlayer)
        } else {
            print("DB Error happened!!!!!!!!")
        }
    }
    
    func updateStartingTable(_ db: Database, orderNum: OrderNum, newData: StartingPlayer) throws {
        switch orderType {
        case .Normal:
            let playerNormal = try StartingNormalTable.fetchOne(db, key: orderNum.order)
            playerNormal?.position = newData.position.description
            playerNormal?.name = newData.name.original
            try playerNormal?.update(db)
        case .DH:
            let playerDH = try StartingDHTable.fetchOne(db, key: orderNum.order)
            playerDH?.position = newData.position.description
            playerDH?.name = newData.name.original
            try playerDH?.update(db)
        case.Special:
            let playerSpecial = try StartingSpecialTable.fetchOne(db, key: orderNum.order)
            playerSpecial?.position = newData.position.description
            playerSpecial?.name = newData.name.original
            try playerSpecial?.update(db)
        default:
            return
        }
    }
    
    func resetData() {
        selectedPosition = Position.Non
        writtenName = Constants.EMPTY
        targetOrderNum = OrderNum(order: 0)
        isExchanging = false
        firstSelectedNum = nil
        secondSelectedNum = nil
    }
    
    func isNumSelected() -> Bool {
        return targetOrderNum.order != 0
    }
    
    func getNumButtonColor(orderNum: OrderNum) -> UIColor {
        if (isNumSelected() && orderNum.order == targetOrderNum.order) {
            return .red
        }
        if (isExchanging && orderNum.order == firstSelectedNum?.order) {
            return .red
        }
        return .systemBlue
    }
    
    func getNumButtonText(orderNum: OrderNum) -> String {
        if isDHPitcher(orderNum: orderNum) {
            return "P"
        } else {
            return "\(orderNum.order)番"
        }
    }
    
    func isDHPitcher(orderNum: OrderNum) -> Bool {
        return (orderNum.order == Constants.SUPPOSED_DHP_ORDER) && (orderType == .DH)
    }
    
    func isHitterWhenDH() -> Bool {
        return (targetOrderNum.order != Constants.SUPPOSED_DHP_ORDER) && (orderType == .DH)
    }
}

protocol OrderVMDelegate: class {
    func prepareRegistering(selectedNum: OrderNum)
    func reloadOrder()
    func setUIDefault()
}
