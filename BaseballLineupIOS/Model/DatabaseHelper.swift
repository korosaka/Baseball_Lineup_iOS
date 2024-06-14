//
//  DatabaseHelper.swift
//  BaseballLineupIOS
//
//  Created by Koro Saka on 2020-11-29.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import Foundation
import GRDB

class DatabaseHelper {
    
    private struct Const {
        static let dbFileName = NSTemporaryDirectory() + "database.db"
    }
    
    init() {
        self.creatDatabase()
    }
    
    func inDatabase(_ block: (Database) throws -> Void) -> Bool {
        do {
            let dbQueue = try DatabaseQueue(path: Const.dbFileName)
            try dbQueue.inDatabase(block)
        }catch _ {
            return false
        }
        return true
    }
    
    private func creatDatabase() {
        if FileManager.default.fileExists(atPath: Const.dbFileName) {
            
            if UsingUserDefaults.isStartingSpecialCreated {
                return
            }
            
            //MARK: When App has been installed before, but not yet since the new version that includes Special(All-Hiiter).
            let result = inDatabase {(db) in
                try StartingSpecialTable.create(db)
                try storeEmptyData(db, isOnlyForSpecial: true)
                try SubSpecialTable.create(db)
            }
            
            if result {
                UsingUserDefaults.createdStartingSpecialTable()
            }
            
        } else {
            //MARK:  initial install
            let result = inDatabase {(db) in
                try StartingNormalTable.create(db)
                try StartingDHTable.create(db)
                try StartingSpecialTable.create(db)
                try storeEmptyData(db)
                try SubNormalTable.create(db)
                try SubDHTable.create(db)
                try SubSpecialTable.create(db)
            }
            
            if result {
                UsingUserDefaults.createdStartingSpecialTable()
            } else {
                do {try FileManager.default.removeItem(atPath: Const.dbFileName)} catch {
                    print("remove DB Error !!!!!!!!!!")
                }
            }
        }
    }
    
    private func storeEmptyData(_ db: Database, isOnlyForSpecial: Bool = false) throws {
        
        for order in Constants.ORDER_FIRST...Constants.MAX_PLAYERS_NUMBER_SPECIAL {
            let playerSpecial = StartingSpecialTable(order: order,
                                                     position: Constants.POSITIONS[Position.Non.indexForOrder],
                                                     name: Constants.EMPTY)
            try playerSpecial.insert(db)
        }
        
        if isOnlyForSpecial { return }
        
        for order in Constants.ORDER_FIRST...Constants.PLAYERS_NUMBER_NORMAL {
            let playerNormal = StartingNormalTable(order: order,
                                                   position: Constants.POSITIONS[Position.Non.indexForOrder],
                                                   name: Constants.EMPTY)
            try playerNormal.insert(db)
        }
        
        for order in Constants.ORDER_FIRST...Constants.PLAYERS_NUMBER_DH {
            let playerDH = StartingDHTable(order: order,
                                           position: Constants.POSITIONS[Position.Non.indexForOrder],
                                           name: Constants.EMPTY)
            try playerDH.insert(db)
        }
    }
}
