//
//  CustomTabBarViewModel.swift
//  BaseballLineupIOS
//
//  Created by Koro Saka on 2020-12-07.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import UIKit
import GRDB

// MARK: for exchanging starting and sub members
class CustomTabBarViewModel {
    var orderType: OrderType?
    var cacheData: CacheOrderData
    var helper: DatabaseHelper
    
    weak var delegate: CustomTabBarVMDelegate?
    
    var isExchangingStartingSub = false
    var subIndexToExchange: Int?
    var startingOrderNumToExchange: OrderNum?
    
    init() {
        cacheData = .init()
        helper = .init()
    }
    
    func selectStartingPlayer(orderNum: OrderNum) {
        startingOrderNumToExchange = orderNum
        exchageStartingSub()
    }
    
    func selectSubPlayer(index: Int) {
        subIndexToExchange = index
    }
    
    func exchageStartingSub() {
        guard let _orderType = orderType,
              let startingNum = startingOrderNumToExchange,
              let subIndex = subIndexToExchange else { return print("error") }
        cacheData.exchangeStartingSubOrder(orderType: _orderType, startingNum: startingNum, subIndex: subIndex)
        
        let newStartingPlayer = cacheData.getStartingOrder(orderType: _orderType)[startingNum.index]
        let newSubPlayer = cacheData.getSubOrder(orderType: _orderType)[subIndex]
        let result = helper.inDatabase{(db) in
            try delegate?.updateStartingSub(db: db,
                                            startingNum: startingNum,
                                            startingPlayer: newStartingPlayer,
                                            subPlayer: newSubPlayer)
        }
        
        if !result {
            print("DB Error happened!!!!!!!!")
        }
        
        resetData()
        delegate?.setUIDefault()
        delegate?.reloadScreens()
    }
    
    func getSubButtonColor(index: Int) -> UIColor {
        guard let selectedIndex = subIndexToExchange else {
            return .systemBlue
        }
        if index == selectedIndex {
            return .red
        } else {
            return .systemBlue
        }
    }
    
    func switchScreen(screenIndex: Int) {
        delegate?.switchScreen(screenIndex)
    }
    
    func resetData() {
        isExchangingStartingSub = false
        subIndexToExchange = nil
        startingOrderNumToExchange = nil
    }
}

protocol CustomTabBarVMDelegate: class {
    func switchScreen(_ screenIndex: Int)
    func reloadScreens()
    func setUIDefault()
    
    func updateStartingSub(db: Database,
                           startingNum: OrderNum,
                           startingPlayer: StartingPlayer,
                           subPlayer: SubPlayer) throws
    
    // MARK: TODO cancel
}
