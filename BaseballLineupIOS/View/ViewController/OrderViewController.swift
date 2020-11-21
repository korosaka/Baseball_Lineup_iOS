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
        if orderVM!.numButtonSelected {
            orderVM?.writtenName = nameTextField.text!
            orderVM?.overWriteStatingPlayer()
            setDefaultUIState()
        }
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
        nameTextField.delegate = self
        positionPicker.delegate = self
        
        setDefaultUIState()
        //        orderTable.delegate = self
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
        
        let order = indexPath.row + 1
        guard let startingPlayer = orderVM?.getStatingPlayer(num: OrderNum(order: order)) else { return orderTableCell }
        orderTableCell.orderNum = startingPlayer.order
        orderTableCell.numButton.setTitle("\(startingPlayer.order.order)番", for: .normal)
        orderTableCell.positionLabel.text = "(\(startingPlayer.position.description))"
        orderTableCell.nameLabel.text = "\(startingPlayer.name)"
        
        return orderTableCell
    }
}

extension OrderViewController: OrderVMDelegate {
    func prepareRegistering(selectedNum: OrderNum) {
        let currentPlayer = orderVM!.getStatingPlayer(num: selectedNum)

        numlabel.text = "\(selectedNum.order)番"
        orderVM?.selectedPosition = currentPlayer.position
        positionPicker.selectRow(currentPlayer.position.index, inComponent: 0, animated: true)
        nameTextField.isEnabled = true
        nameTextField.placeholder = "名前を入力してください"
    }
    
    func setDefaultUIState() {
        numlabel.text = "---"
        positionPicker.selectRow(Position.Non.index, inComponent: 0, animated: true)
        nameTextField.text = Constants.EMPTY
        nameTextField.isEnabled = false
        nameTextField.placeholder = "打順を選択してください"
        orderVM?.resetData()
    }
}

extension OrderViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        return true
    }
}

extension OrderViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        guard let num = orderVM?.getPickerNum() else {
            return 0
        }
        return num
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        orderVM?.selectedPosition = Position(description: Constants.POSITIONS[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {

        let pickerLabel = UILabel()
        pickerLabel.font = UIFont(name:"Helvetica", size: 26)
        pickerLabel.textAlignment = .center
        pickerLabel.text = Constants.POSITIONS[row]
        
        return pickerLabel
    }
}
//extension OrderViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        //
//    }
//}

