//
//  SubPlayerTableCell.swift
//  BaseballLineupIOS
//
//  Created by Koro Saka on 2020-12-07.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import UIKit
class SubPlayerTableCell: UITableViewCell {
    var viewModel: SubMemberViewModel?
    var tableIndex: Int?
    
    @IBOutlet weak var pitcherLabel: UILabel!
    @IBOutlet weak var hitterLabel: UILabel!
    @IBOutlet weak var fielderLabel: UILabel!
    @IBOutlet weak var runnerLabel: UILabel!
    @IBOutlet weak var nameText: UILabel!
    @IBOutlet weak var subButton: UIButton!
    @IBAction func onClickSUb(_ sender: Any) {
        if viewModel!.isDeleting {
            viewModel?.removePlayer(index: tableIndex!)
        }
    }
    
    
}
