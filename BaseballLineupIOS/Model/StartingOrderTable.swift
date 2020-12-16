//
//  StartingPlayerTable.swift
//  BaseballLineupIOS
//
//  Created by Koro Saka on 2020-11-29.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import Foundation
import GRDB

// MARK: I wanna create super class,,,,,

class StartingNormalTable: Record {
    
    override static var databaseTableName: String {
        return "starting_normal"
    }
    
    var order: Int
    var position: String
    var name: String
    
    static func create(_ db: Database) throws {
        try db.create(table: databaseTableName, body: { (t: TableDefinition) in
            t.column("order", .integer).primaryKey(onConflict: .replace, autoincrement: false)
            t.column("position", .text).notNull()
            t.column("name", .text).notNull()
        })
    }
    
    enum Columns {
        static let order = Column("order")
        static let position = Column("position")
        static let name = Column("name")
    }
    
    init(order: Int, position: String, name: String) {
        self.order = order
        self.position = position
        self.name = name
        super.init()
    }
    
    required init(row: Row) {
        self.order = row["order"]
        self.position = row["position"]
        self.name = row["name"]
        super.init(row: row)
    }
    
    override func encode(to container: inout PersistenceContainer) {
        container["order"] = self.order
        container["position"] = self.position
        container["name"] = self.name
    }
}

class StartingDHTable: Record {
    
    override static var databaseTableName: String {
        return "starting_dh"
    }
    
    var order: Int
    var position: String
    var name: String
    
    static func create(_ db: Database) throws {
        try db.create(table: databaseTableName, body: { (t: TableDefinition) in
            t.column("order", .integer).primaryKey(onConflict: .replace, autoincrement: false)
            t.column("position", .text).notNull()
            t.column("name", .text).notNull()
        })
    }
    
    enum Columns {
        static let order = Column("order")
        static let position = Column("position")
        static let name = Column("name")
    }
    
    init(order: Int, position: String, name: String) {
        self.order = order
        self.position = position
        self.name = name
        super.init()
    }
    
    required init(row: Row) {
        self.order = row["order"]
        self.position = row["position"]
        self.name = row["name"]
        super.init(row: row)
    }
    
    override func encode(to container: inout PersistenceContainer) {
        container["order"] = self.order
        container["position"] = self.position
        container["name"] = self.name
    }
}
