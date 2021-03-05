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
        viewModel?.loadOrderInfo()
        displayOrder()
    }
    
    private func displayOrder() {
        pitcherNum.text = viewModel?.pitcherNum
        pitcherName.text = viewModel?.pitcherName
        catcherNum.text = viewModel?.catcherNum
        catcherName.text = viewModel?.catcherName
        firstNum.text = viewModel?.firstNum
        firstName.text = viewModel?.firstName
        secondNum.text = viewModel?.secondNum
        secondName.text = viewModel?.secondName
        thirdNum.text = viewModel?.thirdNum
        thirdName.text = viewModel?.thirdName
        shortNum.text = viewModel?.shortNum
        shortName.text = viewModel?.shortName
        leftNum.text = viewModel?.leftNum
        leftName.text = viewModel?.leftName
        centerNum.text = viewModel?.centerNum
        centerName.text = viewModel?.centerName
        rightNum.text = viewModel?.rightNum
        rightName.text = viewModel?.rightName
        dh1Num.text = viewModel?.dh1Num
        dh1Name.text = viewModel?.dh1Name
    }
}
