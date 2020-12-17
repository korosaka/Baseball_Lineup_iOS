//
//  OrderTableCell.swift
//  BaseballLineupIOS
//
//  Created by Koro Saka on 2020-11-17.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import UIKit
class OrderTableCell: UITableViewCell {
    var orderVM: OrderViewModel?
    var parentViewModel: CustomTabBarViewModel?
    var orderNum: OrderNum?
    
    @IBOutlet weak var numButton: UIButton!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBAction func onClickNum(_ sender: Any) {
        guard let _orderVM = orderVM else { return }
        guard let _parentVM = parentViewModel else { return }
        guard let _orderNum = orderNum else { return }
        
        if _parentVM.isExchangingStartingSub {
            _parentVM.selectStartingPlayer(orderNum: _orderNum)
        } else {
            _orderVM.selectPlayer(selectedNum: _orderNum)
            // MARK: while reloading table, numButton's color will be changed (the reason why button color isn't changed here is because when more than 2 buttons are selected, every selected buttons' color will be changed)
            _orderVM.delegate?.reloadOrder()
        }
        
        
    }
}
