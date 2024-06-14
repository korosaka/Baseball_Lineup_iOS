//
//  SubOrderTable.swift
//  BaseballLineupIOS
//
//  Created by Koro Saka on 2020-12-15.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import Foundation
import GRDB

// MARK: This class must be inherited by sub class. Don't use it by itself.
class SubTable: Record {
    
    var id: String
    var name: String
    var is_pitcher: Int
    var is_hitter: Int
    var is_runner: Int
    var is_fielder: Int
    
    static func create(_ db: Database) throws {
        try db.create(table: databaseTableName, body: { (t: TableDefinition) in
            t.column("id", .text).primaryKey(onConflict: .replace, autoincrement: false)
            t.column("name", .text).notNull()
            t.column("is_pitcher", .integer).notNull()
            t.column("is_hitter", .integer).notNull()
            t.column("is_runner", .integer).notNull()
            t.column("is_fielder", .integer).notNull()
        })
    }
    
    enum Columns {
        static let id = Column("id")
        static let name = Column("name")
        static let is_pitcher = Column("is_pitcher")
        static let is_hitter = Column("is_hitter")
        static let is_runner = Column("is_runner")
        static let is_fielder = Column("is_fielder")
    }
    
    init(id: String, name: String, is_pitcher: Int, is_hitter: Int, is_runner: Int, is_fielder: Int) {
        self.id = id
        self.name = name
        self.is_pitcher = is_pitcher
        self.is_hitter = is_hitter
        self.is_runner = is_runner
        self.is_fielder = is_fielder
        super.init()
    }
    
    required init(row: Row) {
        self.id = row["id"]
        self.name = row["name"]
        self.is_pitcher = row["is_pitcher"]
        self.is_hitter = row["is_hitter"]
        self.is_runner = row["is_runner"]
        self.is_fielder = row["is_fielder"]
        super.init(row: row)
    }
    
    override func encode(to container: inout PersistenceContainer) {
        container["id"] = self.id
        container["name"] = self.name
        container["is_pitcher"] = self.is_pitcher
        container["is_hitter"] = self.is_hitter
        container["is_runner"] = self.is_runner
        container["is_fielder"] = self.is_fielder
    }
}


class SubNormalTable: SubTable {
    
    override static var databaseTableName: String {
        return "sub_normal"
    }
}

class SubDHTable: SubTable {
    
    override static var databaseTableName: String {
        return "sub_dh"
    }
}

class SubSpecialTable: SubTable {
    
    override static var databaseTableName: String {
        return "sub_special"
    }
}
