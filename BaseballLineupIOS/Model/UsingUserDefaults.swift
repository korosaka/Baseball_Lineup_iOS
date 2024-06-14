//
//  UsingUserDefaults.swift
//  BaseballLineupIOS
//
//  Created by 坂公郎 on 2024/06/14.
//  Copyright © 2024 Koro Saka. All rights reserved.
//

import Foundation
class UsingUserDefaults {
    
    static let keyForCreatingSpecialTable = "table_for_special"
   
    static func createdStartingSpecialTable() {
        UserDefaults.standard.set(true, forKey: keyForCreatingSpecialTable)
    }
    
    static var isStartingSpecialCreated: Bool {
        get {
            //if there is no value, return false: https://developer.apple.com/documentation/foundation/userdefaults/1416388-bool
            return UserDefaults.standard.bool(forKey: keyForCreatingSpecialTable)
        }
    }
}
