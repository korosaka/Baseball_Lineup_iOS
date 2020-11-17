//
//  OrderViewModel.swift
//  BaseballLineupIOS
//
//  Created by Koro Saka on 2020-11-11.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import UIKit

class OrderViewModel {
    var orderType: String?
    
    func getOrdeSize() -> Int {
        switch orderType {
        case "NoDH":
            return 9
        case "DH":
            return 10
        default:
            return 0
        }
    }
}
