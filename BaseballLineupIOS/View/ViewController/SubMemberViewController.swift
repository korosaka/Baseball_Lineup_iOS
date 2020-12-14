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
    }
    @IBAction func onClickRegister(_ sender: Any) {
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
        viewModel?.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subPlayerTable.dataSource = self
    }
    
    func setDefaultUIState() {
        titleL.text = "Sub Member"
        viewModel?.setDefault()
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
        
        designRoleLabel(uiLabel: subTableCell.pitcherLabel)
        designRoleLabel(uiLabel: subTableCell.hitterLabel)
        designRoleLabel(uiLabel: subTableCell.runnerLabel)
        designRoleLabel(uiLabel: subTableCell.fielderLabel)
        
        subTableCell.nameText.text = "テスト太郎"
        return subTableCell
    }
    
    func designRoleLabel(uiLabel: UILabel) {
        uiLabel.layer.cornerRadius = 5
        uiLabel.clipsToBounds = true
        uiLabel.layer.borderColor = UIColor.black.cgColor
        uiLabel.layer.borderWidth = 0.7
    }
}

extension SubMemberViewController: SubMemberVMDelegate {
    func reloadOrder() {
        subPlayerTable.reloadData()
        setDefaultUIState()
    }
}
