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
        return cacheData?.getSubOrder(orderType: orderType!).count ?? 0
    }
    
    func getSubOrder() -> [SubPlayer] {
        cacheData!.getSubOrder(orderType: orderType!)
    }
    
    func getSubPlayer(index: Int) -> SubPlayer {
        return getSubOrder()[index]
    }
    
    func addNumOfSub() {
        let emptyPlayer = createEmptyPlayer()
        cacheData?.addSubPlayer(type: orderType!,
                                player: emptyPlayer)
        
        let result = helper!.inDatabase{(db) in
            try insertSubTable(db, newData: emptyPlayer)
        }
        
        if !result {
            print("DB Error happened!!!!!!!!")
        }
        
        delegate?.setDefaultUI()
        delegate?.reloadOrder()
    }
    
    func createEmptyPlayer() -> SubPlayer {
        return SubPlayer(id: UUID().uuidString,
                         name: PlayerName(original: Constants.EMPTY),
                         isPitcher: 0,
                         isHitter: 0,
                         isRunner: 0,
                         isFielder: 0)
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
            return .red
        }
        if (isExchanging && index == firstSelectedIndex) {
            return .red
        }
        return .systemBlue
    }
    
    func overWritePlayer(name: String,
                         isP: Bool,
                         isH: Bool,
                         isR: Bool,
                         isF: Bool) {
        let currentPlayer = getSubPlayer(index: targetIndex!)
        let newPlayer = substituteNewData(origin: currentPlayer, name, isP, isH, isR, isF)
        cacheData?.overWriteSubPlayer(type: orderType!,
                                      index: targetIndex!,
                                      player: newPlayer)
        
        let result = helper!.inDatabase{(db) in
            try updateSubTable(db, newData: newPlayer)
        }
        
        if !result {
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
        let playerToDelete = getSubPlayer(index: index)
        cacheData?.removeSubPlayer(type: orderType!, index)
        
        let result = helper!.inDatabase{(db) in
            try deleteSubTable(db, id: playerToDelete.id)
        }
        
        if !result {
            print("DB Error happened!!!!!!!!")
        }
        
        delegate?.setDefaultUI()
    }
    
    func selectSubButton(index: Int) {
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
        cacheData?.exchangeSubOrder(orderType: orderType!,
                                    index1: firstSelectedIndex!,
                                    index2: secondSelectedIndex!)
        
        let result = helper!.inDatabase{(db) in
            let player1 = getSubPlayer(index: firstSelectedIndex!)
            let player2 = getSubPlayer(index: secondSelectedIndex!)
            try updateSubTable(db, newData: player1)
            try updateSubTable(db, newData: player2)
        }
        
        if !result {
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
        default:
            return
        }
    }
}

protocol SubMemberVMDelegate: class {
    func prepareRegistering(selected: Int)
    func reloadOrder()
    func setDefaultUI()
}
