//
//  OrderViewController.swift
//  BaseballLineupIOS
//
//  Created by Koro Saka on 2020-11-11.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import UIKit

class OrderViewController: UIViewController {
    
    var orderVM: OrderViewModel?
    @IBOutlet weak var orderTable: UITableView!
    @IBOutlet weak var numlabel: UILabel!
    @IBOutlet weak var positionPicker: UIPickerView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBAction func onClickCancel(_ sender: Any) {
    }
    @IBAction func onClickClear(_ sender: Any) {
    }
    @IBAction func onClickExchange(_ sender: Any) {
    }
    @IBAction func onClickRegister(_ sender: Any) {
    }
    
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
        orderVM = .init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        orderTable.dataSource = self
        orderVM?.delegate = self
        //        orderTable.delegate = self
        // Do any additional setup after loading the view.
    }
    
}

extension OrderViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let tableSize = orderVM?.getOrdeSize() else {
            return 0
            
        }
        return tableSize
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let orderTableCell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath) as? OrderTableCell else {
            fatalError("Could not create ReviewCell")
        }
        orderTableCell.orderVM = self.orderVM
        
        
        guard let startingPlayer = orderVM?.getStatingPlyaer(num: indexPath.row) else { return orderTableCell }
        orderTableCell.orderNum = startingPlayer.orderNum
        orderTableCell.numButton.setTitle("\(startingPlayer.orderNum)番", for: .normal)
        orderTableCell.positionLabel.text = "(\(startingPlayer.position))"
        orderTableCell.nameLabel.text = "\(startingPlayer.name)"
        
        return orderTableCell
    }
}

extension OrderViewController: OrderVMDelegate {
    func prepareRegistering(selectedNum: Int) {
        numlabel.text = "\(selectedNum)番"
    }
}

//extension OrderViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        //
//    }
//}

