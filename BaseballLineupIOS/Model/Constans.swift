//
//  Constans.swift
//  BaseballLineupIOS
//
//  Created by Koro Saka on 2020-11-20.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import Foundation
struct Constants {
    
    //MARK: AdMob productID is used only main-branch
    static let BANNER_ID = "ca-app-pub-3940256099942544/2934735716"
    static let INTERSTITIAL_ID = "ca-app-pub-3940256099942544/4411468910"
    
    static let POSITIONS = ["---", "投" ,"捕" ,"一" ,"二" ,"三" ,"遊" ,"左" ,"中" ,"右" ,"DH"]
    static let EMPTY = ""
    static let NOT_REGISTERED = "----"
    static let NO_NUM = "---"
    static let NO_NUM_FOR_FIELD = "-"
    static let DH_PITCHER_NUM = "P"
    
    static let ORDER_FIRST = 1
    static let PLAYERS_NUMBER_NORMAL = 9
    static let PLAYERS_NUMBER_DH = 10
    static let SUPPOSED_DHP_ORDER = 10
    static let MAX_PLAYERS_NUMBER_SPECIAL = 15
    static let MIN_PLAYERS_NUMBER_SPECIAL = 9
}
