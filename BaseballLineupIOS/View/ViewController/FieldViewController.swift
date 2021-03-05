//
//  FieldViewController.swift
//  BaseballLineupIOS
//
//  Created by Koro Saka on 2020-12-07.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import UIKit
class FieldViewController: UIViewController {
    var viewModel: FieldViewModel?
    
    
    @IBOutlet weak var centerNum: UILabel!
    @IBOutlet weak var centerName: UILabel!
    @IBOutlet weak var leftNum: UILabel!
    @IBOutlet weak var leftName: UILabel!
    @IBOutlet weak var rightNum: UILabel!
    @IBOutlet weak var rightName: UILabel!
    @IBOutlet weak var shortNum: UILabel!
    @IBOutlet weak var shortName: UILabel!
    @IBOutlet weak var secondNum: UILabel!
    @IBOutlet weak var secondName: UILabel!
    @IBOutlet weak var thirdNum: UILabel!
    @IBOutlet weak var thirdName: UILabel!
    @IBOutlet weak var firstNum: UILabel!
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var pitcherNum: UILabel!
    @IBOutlet weak var pitcherName: UILabel!
    @IBOutlet weak var dh1Num: UILabel!
    @IBOutlet weak var dh1Name: UILabel!
    @IBOutlet weak var dh2Num: UILabel!
    @IBOutlet weak var dh2Name: UILabel!
    @IBOutlet weak var dh3Num: UILabel!
    @IBOutlet weak var dh3Name: UILabel!
    @IBOutlet weak var dh4Num: UILabel!
    @IBOutlet weak var dh4Name: UILabel!
    @IBOutlet weak var dh5Num: UILabel!
    @IBOutlet weak var dh5Name: UILabel!
    @IBOutlet weak var dh6Num: UILabel!
    @IBOutlet weak var dh6Name: UILabel!
    @IBOutlet weak var catcherNum: UILabel!
    @IBOutlet weak var catcherName: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!) {
        super.init(nibName: nil, bundle: nil)
        setup()
    }
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }
    
    func setup() {
        viewModel = .init()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let orderType = viewModel?.orderType else {
            return
        }
        if orderType == .DH {
            dh1Num.isHidden = false
            dh1Name.isHidden = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //MARK: TODO do in VM!!!
        guard let playersInfo = viewModel?.getStartingOrder() else { return }
        let playerNum = viewModel?.orderType == OrderType.DH ? 10 : 9
        for order in 1...playerNum {
            let orderNum = OrderNum(order: order)
            let player = playersInfo[orderNum.index]
            switch player.position {
            case .Pitcher:
                if viewModel?.orderType == OrderType.DH {
                    pitcherNum.text = "[P]"
                } else {
                    pitcherNum.text = orderNum.forFieldDisplay
                }
                pitcherName.text = player.name.forDisplay
            case .Catcher:
                catcherNum.text = orderNum.forFieldDisplay
                catcherName.text = player.name.forDisplay
            case .First:
                firstNum.text = orderNum.forFieldDisplay
                firstName.text = player.name.forDisplay
            case .Second:
                secondNum.text = orderNum.forFieldDisplay
                secondName.text = player.name.forDisplay
            case .Third:
                thirdNum.text = orderNum.forFieldDisplay
                thirdName.text = player.name.forDisplay
            case .Short:
                shortNum.text = orderNum.forFieldDisplay
                shortName.text = player.name.forDisplay
            case .Left:
                leftNum.text = orderNum.forFieldDisplay
                leftName.text = player.name.forDisplay
            case .Center:
                centerNum.text = orderNum.forFieldDisplay
                centerName.text = player.name.forDisplay
            case .Right:
                rightNum.text = orderNum.forFieldDisplay
                rightName.text = player.name.forDisplay
            case .DH:
                dh1Num.text = orderNum.forFieldDisplay
                dh1Name.text = player.name.forDisplay
            default:
                print("do nothing")
            }
        }
    }
}
