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
    var selectedPosition = Position.Non
    var writtenName = Constants.EMPTY
    
    weak var delegate: OrderVMDelegate?
    
    var numButtonSelected = false
    var isExchanging = false
    var firstSelectedNum: OrderNum?
    var secondSelectedNum: OrderNum?
    
    var targetOrderNum = OrderNum(order: 0)
    
    init() {
        cacheData = CacheOrderData()
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
            self.targetOrderNum = selectedNum
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
    
    func overWriteStatingPlayer() {
        let player = StartingPlayer(order: targetOrderNum,
                                    position: selectedPosition,
                                    name: PlayerName(original: writtenName))
        cacheData.overWriteStartingPlayer(type: orderType!,
                                          player: player)
    }
    
    func resetData() {
        selectedPosition = Position.Non
        writtenName = Constants.EMPTY
        numButtonSelected = false
        targetOrderNum = OrderNum(order: 0)
        isExchanging = false
    }
    
}

protocol OrderVMDelegate: class {
    func prepareRegistering(selectedNum: OrderNum)
    func reloadOrder()
}
