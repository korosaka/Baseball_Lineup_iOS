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
    
    private var nameLabels = [UILabel]()
    private var orderNumLabels = [UILabel]()
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
        putUILabelsIntoArray()
        customNameLabels()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.loadOrderInfo()
        displayOrder()
    }
    
    private func putUILabelsIntoArray() {
        nameLabels.append(pitcherName)
        nameLabels.append(catcherName)
        nameLabels.append(firstName)
        nameLabels.append(secondName)
        nameLabels.append(thirdName)
        nameLabels.append(shortName)
        nameLabels.append(leftName)
        nameLabels.append(centerName)
        nameLabels.append(rightName)
        nameLabels.append(dh1Name)
        
        orderNumLabels.append(pitcherNum)
        orderNumLabels.append(catcherNum)
        orderNumLabels.append(firstNum)
        orderNumLabels.append(secondNum)
        orderNumLabels.append(thirdNum)
        orderNumLabels.append(shortNum)
        orderNumLabels.append(leftNum)
        orderNumLabels.append(centerNum)
        orderNumLabels.append(rightNum)
        orderNumLabels.append(dh1Num)
    }
    
    private func customNameLabels() {
        guard let vm = viewModel else { return }
        let radiusValue = CGFloat(10.0)
        let borderWith = CGFloat(1.0)
        let borderColor = UIColor.black.cgColor
        
        for index in 0..<nameLabels.count {
            let label = nameLabels[index]
            label.layer.cornerRadius = radiusValue
            label.layer.borderWidth = borderWith
            label.layer.borderColor = borderColor
            label.backgroundColor = vm.getNameLabelColor(index)
        }
    }
    
    private func displayOrder() {
        guard let vm = viewModel else { return }
        for index in 0..<nameLabels.count {
            nameLabels[index].text = vm.getPlayerName(index)
            orderNumLabels[index].text = vm.getOrderNum(index)
        }
    }
}
