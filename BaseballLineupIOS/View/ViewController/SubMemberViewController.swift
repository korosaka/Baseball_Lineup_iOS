//
//  SubMemberViewController.swift
//  BaseballLineupIOS
//
//  Created by Koro Saka on 2020-12-07.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import UIKit

class SubMemberViewController: UIViewController {
    
    var viewModel: SubMemberViewModel?
    var parentViewModel: CustomTabBarViewModel?
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var pitcherS: UISwitch!
    @IBOutlet weak var hitterS: UISwitch!
    @IBOutlet weak var runnerS: UISwitch!
    @IBOutlet weak var fielderS: UISwitch!
    @IBOutlet weak var cancelB: UIButton!
    @IBOutlet weak var registerB: UIButton!
    @IBOutlet weak var exchangeB: UIButton!
    @IBOutlet weak var subPlayerTable: UITableView!
    @IBOutlet weak var titleL: UILabel!
    
    @IBOutlet weak var addB: UIButton!
    @IBOutlet weak var deleteB: UIButton!
    @IBAction func onClickCancel(_ sender: Any) {
        setDefaultUIState()
    }
    @IBAction func onClickRegister(_ sender: Any) {
        if viewModel!.isSelected() {
            viewModel!.overWritePlayer(name: nameTF.text!,
                                       isP: pitcherS.isOn,
                                       isH: hitterS.isOn,
                                       isR: runnerS.isOn,
                                       isF: fielderS.isOn)
            subPlayerTable.reloadData()
            setDefaultUIState()
        }
    }
    @IBAction func onClickExchange(_ sender: Any) {
    }
    @IBAction func onClickAdd(_ sender: Any) {
        viewModel?.addNumOfSub()
        subPlayerTable.reloadData()
    }
    @IBAction func onClickDelete(_ sender: Any) {
        viewModel?.isDeleting = true
        titleL.text = "select sub player to delete"
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
        viewModel = .init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subPlayerTable.dataSource = self
        viewModel?.delegate = self
        setDefaultUIState()
    }
    
    func setDefaultUIState() {
        nameTF.placeholder = "控えを選択してください"
        nameTF.text = Constants.EMPTY
        titleL.text = "Sub Member"
        pitcherS.setOn(false, animated: true)
        hitterS.setOn(false, animated: true)
        runnerS.setOn(false, animated: true)
        fielderS.setOn(false, animated: true)
        setItemsEnabled(false)
        viewModel?.setDefault()
    }
    
    func setItemsEnabled(_ isInput: Bool) {
        nameTF.isEnabled = isInput
        pitcherS.isEnabled = isInput
        hitterS.isEnabled = isInput
        runnerS.isEnabled = isInput
        fielderS.isEnabled = isInput
        cancelB.isEnabled = isInput
        registerB.isEnabled = isInput
        exchangeB.isEnabled = !isInput
    }
}

extension SubMemberViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.getOrdeSize() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let subTableCell = tableView.dequeueReusableCell(withIdentifier: "SubPlayerTableCell", for: indexPath) as? SubPlayerTableCell else {
            fatalError("Could not create ReviewCell")
        }
        subTableCell.viewModel = self.viewModel
        subTableCell.tableIndex = indexPath.row
        
        subTableCell.subButton.backgroundColor = .systemBlue
        subTableCell.subButton.layer.cornerRadius = 15
        subTableCell.subButton.layer.borderColor = UIColor.black.cgColor
        subTableCell.subButton.layer.borderWidth = 2
        
        let player = viewModel!.getSubPlayer(index: indexPath.row)
        designRoleLabel(uiLabel: subTableCell.pitcherLabel,
                        isOn: player.isPitcher.convertToBool(),
                        color: .red)
        designRoleLabel(uiLabel: subTableCell.hitterLabel,
                        isOn: player.isHitter.convertToBool(),
                        color: .green)
        designRoleLabel(uiLabel: subTableCell.runnerLabel,
                        isOn: player.isRunner.convertToBool(),
                        color: .blue)
        designRoleLabel(uiLabel: subTableCell.fielderLabel,
                        isOn: player.isFielder.convertToBool(),
                        color: .yellow)
        subTableCell.nameText.text = player.name.forDisplay
        
        return subTableCell
    }
    
    func designRoleLabel(uiLabel: UILabel, isOn: Bool, color: UIColor) {
        uiLabel.layer.cornerRadius = 5
        uiLabel.clipsToBounds = true
        uiLabel.layer.borderColor = UIColor.black.cgColor
        uiLabel.layer.borderWidth = 0.7
        if isOn {
            uiLabel.backgroundColor = color
        } else {
            uiLabel.backgroundColor = .gray
        }
    }
}

extension SubMemberViewController: SubMemberVMDelegate {
    func reloadOrder() {
        subPlayerTable.reloadData()
        setDefaultUIState()
    }
    
    func prepareRegistering(selected: Int) {
        setItemsEnabled(true)
        
        let currentPlayer = viewModel!.getSubPlayer(index: selected)
        nameTF.placeholder = "名前を入力してください"
        nameTF.text = currentPlayer.name.original
        pitcherS.setOn(currentPlayer.isPitcher.convertToBool(), animated: true)
        hitterS.setOn(currentPlayer.isHitter.convertToBool(), animated: true)
        runnerS.setOn(currentPlayer.isRunner.convertToBool(), animated: true)
        fielderS.setOn(currentPlayer.isFielder.convertToBool(), animated: true)
    }
}
