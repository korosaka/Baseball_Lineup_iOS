//
//  SubMemberViewModel.swift
//  BaseballLineupIOS
//
//  Created by Koro Saka on 2020-12-07.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import SwiftUI

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
        cacheData?.addSubPlayer(type: orderType!,
                                player: createEmptyPlayer())
        
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
        cacheData?.removeSubPlayer(type: orderType!, index)
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
        
        // MARK: TODO DB exchange
        
        delegate?.setDefaultUI()
        delegate?.reloadOrder()
    }
}

protocol SubMemberVMDelegate: class {
    func prepareRegistering(selected: Int)
    func reloadOrder()
    func setDefaultUI()
}
