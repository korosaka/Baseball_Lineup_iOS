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
            return
        }
        let result = inDatabase {(db) in
            try StartingNormalTable.create(db)
            try StartingDHTable.create(db)
            
            // MARK: set Empty data to update
            for order in 1...9 {
                let playerNormal = StartingNormalTable(order: order,
                                                       position: Constants.POSITIONS[Position.Non.index],
                                                       name: Constants.EMPTY)
                try playerNormal.insert(db)
            }
            
            for order in 1...10 {
                let playerDH = StartingDHTable(order: order,
                                               position: Constants.POSITIONS[Position.Non.index],
                                               name: Constants.EMPTY)
                try playerDH.insert(db)
            }
        }
        
        if !result {
            do {try FileManager.default.removeItem(atPath: Const.dbFileName)} catch {
                print("remove DB Error !!!!!!!!!!")
            }
        }
    }
}
