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
    static let keyForPurchasingSpecial = "purchase_special"
    static let keyForAppUsingCount = "app_use_count"
    static let keyForSavedInterstitialTime = "saved_interstitial_time"
    
    static func createdStartingSpecialTable() {
        UserDefaults.standard.set(true, forKey: keyForCreatingSpecialTable)
    }
    
    static var isStartingSpecialCreated: Bool {
        get {
            //if there is no value, return false: https://developer.apple.com/documentation/foundation/userdefaults/1416388-bool
            return UserDefaults.standard.bool(forKey: keyForCreatingSpecialTable)
        }
    }
    
    static func purchasedSpecial() {
        UserDefaults.standard.set(true, forKey: keyForPurchasingSpecial)
    }
    
    static var isSpecialPurchased: Bool {
        get {
            return UserDefaults.standard.bool(forKey: keyForPurchasingSpecial)
        }
    }
    
    static func countUpAppUsing() {
        let currentCount = countOfUsingApp
        UserDefaults.standard.setValue(currentCount + 1, forKey: keyForAppUsingCount)
    }
    
    static var countOfUsingApp: Int {
        get {
            // If the specified key doesn‘t exist, this method returns 0: https://developer.apple.com/documentation/foundation/userdefaults/1407405-integer
            return UserDefaults.standard.integer(forKey: keyForAppUsingCount)
        }
    }
    
    static func saveInterstitialTime() {
        let currentTime = Date()
        UserDefaults.standard.set(currentTime, forKey: keyForSavedInterstitialTime)
    }
    
    static var savedInterstitialTime: Date? {
        guard let savedTime = UserDefaults.standard.object(forKey: keyForSavedInterstitialTime) as? Date else {
            return nil
        }
        return savedTime
    }
}
