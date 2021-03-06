//
//  TopViewModel.swift
//  BaseballLineupIOS
//
//  Created by Koro Saka on 2020-11-11.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import UIKit

class TopViewModel {
    
    func informOrderType(segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goOrderScreen" {
            let tabBarController = segue.destination as! CustomTabBarController
            tabBarController.viewModel?.orderType = sender as? OrderType
        }
    }
}
