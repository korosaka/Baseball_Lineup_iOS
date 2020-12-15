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
    var firstSelectedNum: OrderNum?
    var secondSelectedNum: OrderNum?
    
    var targetOrderNum = OrderNum(order: 0)
    
    func getOrdeSize() -> Int {
        switch orderType {
        case .Normal:
            return 9
        case .DH:
            return 10
        default:
            return 0
        }
    }
    
    func getStatingOrder() -> [StartingPlayer] {
        cacheData!.getStartingOrder(orderType: orderType!)
    }
    
    func getStatingPlayer(num: OrderNum) -> StartingPlayer {
        return getStatingOrder()[num.index]
    }
    
    func selectNumButton(selectedNum: OrderNum) {
        if isExchanging {
            if firstSelectedNum == nil {
                firstSelectedNum = selectedNum
            } else if firstSelectedNum?.order == selectedNum.order {
                firstSelectedNum = nil
            } else {
                exchangeStartingPlayers(selectedNum)
            }
        } else {
            targetOrderNum = selectedNum
            delegate?.prepareRegistering(selectedNum: selectedNum)
        }
    }
    
    func exchangeStartingPlayers(_ selectedNum: OrderNum) {
        secondSelectedNum = selectedNum
        cacheData!.exchangeOrder(orderType: orderType!, num1: firstSelectedNum!, num2: secondSelectedNum!)
        
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
    
    func getPickerNum() -> Int {
        switch orderType {
        case .Normal:
            return 10
        case .DH:
            return 11
        default:
            return 0
        }
    }
    
    func fetchData() {
        cacheData!.fetchOrderFromDB(orderType!, helper!)
    }
    
    func overWriteStatingPlayer() {
        let newPlayer = StartingPlayer(position: selectedPosition,
                                       name: PlayerName(original: writtenName))
        
        cacheData!.overWriteStartingPlayer(type: orderType!,
                                           orderNum: targetOrderNum,
                                           player: newPlayer)
        
        let result = helper!.inDatabase{(db) in
            try updateStartingTable(db, orderNum: targetOrderNum, newData: newPlayer)
        }
        
        if !result {
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
        return (orderNum.order == 10) && (orderType == .DH)
    }
    
    func isDHFielder() -> Bool {
        return (targetOrderNum.order != 10) && (orderType == .DH)
    }
}

protocol OrderVMDelegate: class {
    func prepareRegistering(selectedNum: OrderNum)
    func reloadOrder()
    func setUIDefault()
}
