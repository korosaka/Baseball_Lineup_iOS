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
    var orderNum: OrderNum?
    
    @IBOutlet weak var numButton: UIButton!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBAction func onClickNum(_ sender: Any) {
        self.orderVM?.selectNumButton(selectedNum: orderNum!)
    }
}
