//
//  OrderViewModel.swift
//  BaseballLineupIOS
//
//  Created by Koro Saka on 2020-11-11.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import UIKit

class OrderViewModel {
    var orderType: OrderType?
    var cacheData: CacheOrderData
    var helper: DatabaseHelper
    var selectedPosition = Position.Non
    var writtenName = Constants.EMPTY
    
    weak var delegate: OrderVMDelegate?
    
    var numButtonSelected = false
    var isExchanging = false
    var firstSelectedNum: OrderNum?
    var secondSelectedNum: OrderNum?
    
    var targetOrderNum = OrderNum(order: 0)
    
    init() {
        helper = .init()
        cacheData = .init()
    }
    
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
        cacheData.getOrder(orderType: orderType!)
    }
    
    func getStatingPlayer(num: OrderNum) -> StartingPlayer {
        return getStatingOrder()[num.index]
    }
    
    func cancelExchange() {
        firstSelectedNum = nil
        secondSelectedNum = nil
        isExchanging = false
        // MARK: to reset button color
        delegate?.reloadOrder()
    }
    
    func selectNumButton(selectedNum: OrderNum) {
        if isExchanging {
            if firstSelectedNum == nil {
                firstSelectedNum = selectedNum
            } else if firstSelectedNum?.order == selectedNum.order {
                firstSelectedNum = nil
            } else {
                secondSelectedNum = selectedNum
                cacheData.exchangeOrder(orderType: orderType!, num1: firstSelectedNum!, num2: secondSelectedNum!)
                delegate?.reloadOrder()
                cancelExchange()
            }
        } else {
            numButtonSelected = true
            targetOrderNum = selectedNum
            delegate?.prepareRegistering(selectedNum: selectedNum)
        }
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
        cacheData.fetchOrderFromDB(orderType!, helper)
    }
    
    func overWriteStatingPlayer() {
        let newPlayer = StartingPlayer(order: targetOrderNum,
                                    position: selectedPosition,
                                    name: PlayerName(original: writtenName))
        
        cacheData.overWriteStartingPlayer(type: orderType!,
                                          player: newPlayer)
        
        let result = helper.inDatabase{(db) in
            switch orderType {
            case .Normal:
                // MARK: "key" means Primary Key
                let playerNormal = try StartingNormalTable.fetchOne(db, key: newPlayer.order.order)
                playerNormal?.position = newPlayer.position.description
                playerNormal?.name = newPlayer.name.original
                try playerNormal?.update(db)
                
            case .DH:
                let playerDH = try StartingDHTable.fetchOne(db, key: newPlayer.order.order)
                playerDH?.position = newPlayer.position.description
                playerDH?.name = newPlayer.name.original
                try playerDH?.update(db)
                
            default:
                return
            }
        }
        
        if !result {
            print("DB Error happened!!!!!!!!")
        }
    }
    
    func resetData() {
        selectedPosition = Position.Non
        writtenName = Constants.EMPTY
        numButtonSelected = false
        targetOrderNum = OrderNum(order: 0)
        isExchanging = false
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
    
    func getNumButtonColor(orderNum: OrderNum) -> UIColor {
        if isExchanging {
            if firstSelectedNum == nil {
                return .red
            } else if firstSelectedNum!.order == orderNum.order {
                return .blue
            } else {
                return .red
            }
        } else {
            return .blue
        }
    }
    
}

protocol OrderVMDelegate: class {
    func prepareRegistering(selectedNum: OrderNum)
    func reloadOrder()
}
