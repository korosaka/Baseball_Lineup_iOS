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
    
    //Alert Message
    static let OK = "OK"
    static let TITLE_COMPLETE = "完了"
    static let TITLE_ERROR = "エラー"
    static let TITLE_PENDING = "保留"
    static let TITLE_CANCEL = "キャンセル"
    static let TITLE_PURCHASED = "購入済み"
    static let FAIL_RESTORE = "復元が失敗しました。"
    static let SUCCESS_RESTORE = "購入履歴の復元が完了いたしました。"
    static let EMPTY_RESTORE = "対象の購入履歴はありませんでした。"
    static let FAIL_PURCHASE = "購入に失敗しました。\nまたお時間をおいてお試しください。"
    static let SUCCESS_PURCHASE = "購入が完了いたしました。\nありがとうございました。"
    static let PENDING_PURCHASE = "購入は保留されています。"
    static let CANCEL_PURCHASE = "購入は中止されました。"
    static let HAD_PURCHASED = "お客様は既に購入済みでした。\n(お支払いは不要です)"
    static let GO_TO_PURCHASE = "購入手続へ"
    static let FAIL_FETCH_PRODUCT = "インターネットの通信状態を確認してください。\n時間をおいてもう一度お試しください。"
    
    //All-Hitter
    static let ALL_HITTER_ID = "all_hitter_rule"
    static let ALL_HITTER_AVAILABLE = "全員打ち"
    static let ALL_HITTER_UNAVAILABLE = "全員打ち(有料)"
    static let ALL_HITTER_DESC_1 = "\n\n価格:"
    static let ALL_HITTER_DESC_2 = "\n買い切りですので支払いは1度きりです。\nサブスクではありませんのでご安心ください。"
    
    //Policy
    static let PRIVACY_POLICY = "プライバシーポリシー"
    static let PRIVACY_POLICY_URL = "https://korosaka.github.io/privacy_policy_for_baseball_lineup_ios/"
    static let TERMS_OF_USE = "利用規約"
    static let TERMS_OF_USE_URL = "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/"
    
    //Top
    static let TITLE_TOP = "野球スタメン\n作成アプリ"
    static let NON_DH = "DHなし"
    static let USE_DH = "DHあり"
    static let RESTORE_PURCHASE = "購入を復元"
    static let WHAT_IS_ALL_HITTER = "全員打ちとは"
    static let DESCRIPTION_1 = "※購入が反映されない時は復元ボタンをお試しください"
    static let DESCRIPTION_2 = "※購入は「\(WHAT_IS_ALL_HITTER)」から可能です"
    static let DESCRIPTION_3 = "※上記操作はインターネット環境が必要となります"
    
    //Order&Sub Order
    static let SELECT_ORDER_NUM = "打順ボタンを押してください"
    static let SELECT_SUB = "控えを選択してください"
}
