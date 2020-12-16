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
    var parentViewModel: CustomTabBarViewModel?
    var tableIndex: Int?
    
    @IBOutlet weak var pitcherLabel: UILabel!
    @IBOutlet weak var hitterLabel: UILabel!
    @IBOutlet weak var fielderLabel: UILabel!
    @IBOutlet weak var runnerLabel: UILabel!
    @IBOutlet weak var nameText: UILabel!
    @IBOutlet weak var subButton: UIButton!
    @IBAction func onClickSub(_ sender: Any) {
        
        guard let _index = tableIndex else { return }
        guard let _parentVM = parentViewModel else { return }
        guard let _VM = viewModel else { return }
        
        if _parentVM.isExchangingStartingSub {
            _parentVM.selectSubButton(index: _index)
            _VM.delegate?.reloadOrder()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                _parentVM.switchScreen(screenIndex: 0)
            }
            
        } else {
            _VM.selectSubButton(index: _index)
            _VM.delegate?.reloadOrder()
        }
        
    }
    
    
}
