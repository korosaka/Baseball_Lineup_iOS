//
//  SubMemberViewModel.swift
//  BaseballLineupIOS
//
//  Created by Koro Saka on 2020-12-07.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import Foundation

class SubMemberViewModel {
    var orderType: OrderType?
    var cacheData: CacheOrderData?
    var helper: DatabaseHelper?
    var isDeleting = false
    var selectedIndex = -1
    
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
        selectedIndex = -1
    }
    
    func isSelected() -> Bool {
        return selectedIndex != -1
    }
    
    func overWritePlayer(name: String,
                         isP: Bool,
                         isH: Bool,
                         isR: Bool,
                         isF: Bool) {
        let currentPlayer = getSubPlayer(index: selectedIndex)
        let newPlayer = substituteNewData(origin: currentPlayer, name, isP, isH, isR, isF)
        cacheData?.overWriteSubPlayer(type: orderType!,
                                      index: selectedIndex,
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
        delegate?.reloadOrder()
    }
    
    func selectSubButton(index: Int) {
        selectedIndex = index
        delegate?.prepareRegistering(selected: index)
    }
}

protocol SubMemberVMDelegate: class {
    func prepareRegistering(selected: Int)
    func reloadOrder()
}
