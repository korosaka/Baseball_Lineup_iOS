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
        
        let currentStartingPlayer = cacheData.getStartingOrder(orderType: _orderType)[startingNum.index]
        let currentSubPlayer = cacheData.getSubOrder(orderType: _orderType)[subIndex]
        
        let newStartingPlayer = StartingPlayer(position: currentStartingPlayer.position,
                                               name: currentSubPlayer.name)
        let newSubPlayer = SubPlayer(id: currentSubPlayer.id,
                                     name: currentStartingPlayer.name,
                                     isPitcher: currentSubPlayer.isPitcher,
                                     isHitter: currentSubPlayer.isHitter,
                                     isRunner: currentSubPlayer.isRunner,
                                     isFielder: currentSubPlayer.isFielder)
        
        let result = helper.inDatabase{(db) in
            try delegate?.updateStartingSub(db: db,
                                            startingNum: startingNum,
                                            startingPlayer: newStartingPlayer,
                                            subPlayer: newSubPlayer)
        }
        
        if result {
            cacheData.exchangeStartingSubOrder(orderType: _orderType, startingNum: startingNum, subIndex: subIndex)
        } else {
            print("DB Error happened!!!!!!!!")
        }
        
        resetData()
        resetUI()
        reloadTables()
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
    
    func resetUI() {
        delegate?.setUIDefault()
    }
    
    func reloadTables() {
        delegate?.reloadTables()
    }
}

protocol CustomTabBarVMDelegate: AnyObject {
    func switchScreen(_ screenIndex: Int)
    func reloadTables()
    func setUIDefault()
    func updateStartingSub(db: Database,
                           startingNum: OrderNum,
                           startingPlayer: StartingPlayer,
                           subPlayer: SubPlayer) throws
}
