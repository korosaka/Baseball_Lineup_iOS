//
//  SubMemberViewModel.swift
//  BaseballLineupIOS
//
//  Created by Koro Saka on 2020-12-07.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import UIKit
import GRDB

class SubMemberViewModel {
    var orderType: OrderType?
    var cacheData: CacheOrderData?
    var helper: DatabaseHelper?
    var isDeleting = false
    var targetIndex: Int?
    
    var isExchanging = false
    // MARK: this 2 num should be tupple?
    var firstSelectedIndex: Int?
    var secondSelectedIndex: Int?
    
    weak var delegate: SubMemberVMDelegate?
    
    func getOrdeSize() -> Int {
        guard let _cacheData = cacheData, let _orderType = orderType else { return 0 }
        return _cacheData.getSubOrder(orderType: _orderType).count
    }
    
    func getSubOrder() -> [SubPlayer] {
        guard let _cacheData = cacheData, let _orderType = orderType else { return [] }
        return _cacheData.getSubOrder(orderType: _orderType)
    }
    
    func getSubPlayer(index: Int) -> SubPlayer {
        return getSubOrder()[index]
    }
    
    func addNumOfSub() {
        guard let _orderType = orderType,
              let _helper = helper else { return }
        
        let emptyPlayer = createEmptyPlayer()
        let result = _helper.inDatabase{(db) in
            try insertSubTable(db, newData: emptyPlayer)
        }
        
        if result {
            cacheData?.addSubPlayer(type: _orderType,
                                    player: emptyPlayer)
        } else {
            print("DB Error happened!!!!!!!!")
        }
        
        delegate?.setDefaultUI()
        delegate?.reloadOrder()
    }
    
    func createEmptyPlayer() -> SubPlayer {
        let falseNum = false.convertToInt()
        return SubPlayer(id: UUID().uuidString,
                         name: PlayerName(),
                         isPitcher: falseNum,
                         isHitter: falseNum,
                         isRunner: falseNum,
                         isFielder: falseNum)
    }
    
    func setDefault() {
        isDeleting = false
        targetIndex = nil
        isExchanging = false
        firstSelectedIndex = nil
        secondSelectedIndex = nil
    }
    
    func isSelected() -> Bool {
        return targetIndex != nil
    }
    
    func getNumButtonColor(index: Int) -> UIColor {
        if (isSelected() && index == targetIndex) {
            return .selectedNumButtonColor
        }
        if (isExchanging && index == firstSelectedIndex) {
            return .selectedNumButtonColor
        }
        return .numButtonColor
    }
    
    func overWritePlayer(name: String,
                         isP: Bool,
                         isH: Bool,
                         isR: Bool,
                         isF: Bool) {
        guard let _targetIndex = targetIndex,
              let _orderType = orderType,
              let _helper = helper else { return }
        
        let currentPlayer = getSubPlayer(index: _targetIndex)
        let newPlayer = substituteNewData(origin: currentPlayer, name, isP, isH, isR, isF)
        
        let result = _helper.inDatabase{(db) in
            try updateSubTable(db, newData: newPlayer)
        }
        
        if result {
            cacheData?.overWriteSubPlayer(type: _orderType,
                                          index: _targetIndex,
                                          player: newPlayer)
        } else {
            print("DB Error happened!!!!!!!!")
        }
        
        delegate?.setDefaultUI()
        delegate?.reloadOrder()
    }
    
    func substituteNewData(origin: SubPlayer,
                           _ name: String,
                           _ isP: Bool,
                           _ isH: Bool,
                           _ isR: Bool,
                           _ isF: Bool) -> SubPlayer {
        var newPlayer = origin
        newPlayer.name = PlayerName(original: name)
        newPlayer.isPitcher = isP.convertToInt()
        newPlayer.isHitter = isH.convertToInt()
        newPlayer.isRunner = isR.convertToInt()
        newPlayer.isFielder = isF.convertToInt()
        
        return newPlayer
    }
    
    func removePlayer(index: Int) {
        guard let _orderType = orderType,
              let _helper = helper else { return }
        
        let playerToDelete = getSubPlayer(index: index)
        
        let result = _helper.inDatabase{(db) in
            try deleteSubTable(db, id: playerToDelete.id)
        }
        
        if result {
            cacheData?.removeSubPlayer(type: _orderType, index)
        } else {
            print("DB Error happened!!!!!!!!")
        }
        
        delegate?.setDefaultUI()
    }
    
    func selectPlayer(index: Int) {
        if isDeleting {
            removePlayer(index: index)
        } else if isExchanging {
            if firstSelectedIndex == nil {
                firstSelectedIndex = index
            } else if firstSelectedIndex == index {
                firstSelectedIndex = nil
            } else {
                secondSelectedIndex = index
                exchangeSubPlayers()
            }
        } else {
            targetIndex = index
            delegate?.prepareRegistering(selected: index)
        }
        
    }
    
    func exchangeSubPlayers() {
        guard let _orderType = orderType,
              let _helper = helper,
              let fisrtSelect = firstSelectedIndex,
              let secondSelect = secondSelectedIndex else { return }
        
        let result = _helper.inDatabase{(db) in
            let player1 = getSubPlayer(index: fisrtSelect)
            let player2 = getSubPlayer(index: secondSelect)
            
            let newPlayer1 = SubPlayer(id: player1.id,
                                       name: player2.name,
                                       isPitcher: player2.isPitcher,
                                       isHitter: player2.isHitter,
                                       isRunner: player2.isRunner,
                                       isFielder: player2.isFielder)
            let newPlayer2 = SubPlayer(id: player2.id,
                                       name: player1.name,
                                       isPitcher: player1.isPitcher,
                                       isHitter: player1.isHitter,
                                       isRunner: player1.isRunner,
                                       isFielder: player1.isFielder)
            
            try updateSubTable(db, newData: newPlayer1)
            try updateSubTable(db, newData: newPlayer2)
        }
        
        if result {
            cacheData?.exchangeSubOrder(orderType: _orderType,
                                        index1: fisrtSelect,
                                        index2: secondSelect)
        } else {
            print("DB Error happened!!!!!!!!")
        }
        
        delegate?.setDefaultUI()
        delegate?.reloadOrder()
    }
    
    func insertSubTable(_ db: Database, newData: SubPlayer) throws {
        
        switch orderType {
        case .Normal:
            let playerNormal = SubNormalTable(id: newData.id,
                                              name: newData.name.original,
                                              is_pitcher: newData.isPitcher,
                                              is_hitter: newData.isHitter,
                                              is_runner: newData.isRunner,
                                              is_fielder: newData.isFielder)
            try playerNormal.insert(db)
        case .DH:
            let playerDH = SubDHTable(id: newData.id,
                                      name: newData.name.original,
                                      is_pitcher: newData.isPitcher,
                                      is_hitter: newData.isHitter,
                                      is_runner: newData.isRunner,
                                      is_fielder: newData.isFielder)
            try playerDH.insert(db)
        case .Special:
            let playerSpecial = SubSpecialTable(id: newData.id,
                                                name: newData.name.original,
                                                is_pitcher: newData.isPitcher,
                                                is_hitter: newData.isHitter,
                                                is_runner: newData.isRunner,
                                                is_fielder: newData.isFielder)
            try playerSpecial.insert(db)
        default:
            return
        }
    }
    
    func deleteSubTable(_ db: Database, id: String) throws {
        switch orderType {
        case .Normal:
            let playerNormal = try SubNormalTable.fetchOne(db, key: id)
            try playerNormal?.delete(db)
        case .DH:
            let playerDH = try SubDHTable.fetchOne(db, key: id)
            try playerDH?.delete(db)
        case .Special:
            let playerSpecial = try SubSpecialTable.fetchOne(db, key: id)
            try playerSpecial?.delete(db)
        default:
            return
        }
    }
    
    func updateSubTable(_ db: Database, newData: SubPlayer) throws {
        switch orderType {
        case .Normal:
            let playerNormal = try SubNormalTable.fetchOne(db, key: newData.id)
            playerNormal?.name = newData.name.original
            playerNormal?.is_pitcher = newData.isPitcher
            playerNormal?.is_hitter = newData.isHitter
            playerNormal?.is_runner = newData.isRunner
            playerNormal?.is_fielder = newData.isFielder
            try playerNormal?.update(db)
        case .DH:
            let playerDH = try SubDHTable.fetchOne(db, key: newData.id)
            playerDH?.name = newData.name.original
            playerDH?.is_pitcher = newData.isPitcher
            playerDH?.is_hitter = newData.isHitter
            playerDH?.is_runner = newData.isRunner
            playerDH?.is_fielder = newData.isFielder
            try playerDH?.update(db)
        case .Special:
            let playerSpecial = try SubSpecialTable.fetchOne(db, key: newData.id)
            playerSpecial?.name = newData.name.original
            playerSpecial?.is_pitcher = newData.isPitcher
            playerSpecial?.is_hitter = newData.isHitter
            playerSpecial?.is_runner = newData.isRunner
            playerSpecial?.is_fielder = newData.isFielder
            try playerSpecial?.update(db)
        default:
            return
        }
    }
}

protocol SubMemberVMDelegate: AnyObject {
    func prepareRegistering(selected: Int)
    func reloadOrder()
    func setDefaultUI()
}
