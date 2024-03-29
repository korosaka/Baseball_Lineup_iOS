//
//  SubMemberViewController.swift
//  BaseballLineupIOS
//
//  Created by Koro Saka on 2020-12-07.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import UIKit
import GoogleMobileAds
class SubMemberViewController: BaseADViewController {
    
    var viewModel: SubMemberViewModel?
    var parentViewModel: CustomTabBarViewModel?
    @IBOutlet weak var subL: UILabel!
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
    @IBOutlet weak var exchangeWithStartingB: UIButton!
    @IBAction func onClickCancel(_ sender: Any) {
        guard let _parentVM = parentViewModel else { return print("error happened!") }
        if _parentVM.isExchangingStartingSub {
            _parentVM.resetData()
            _parentVM.reloadTables()
            _parentVM.resetUI()
        } else {
            setDefaultUIState()
            reloadOrder()
        }
    }
    @IBAction func onClickRegister(_ sender: Any) {
        if viewModel!.isSelected() {
            viewModel!.overWritePlayer(name: nameTF.text!,
                                       isP: pitcherS.isOn,
                                       isH: hitterS.isOn,
                                       isR: runnerS.isOn,
                                       isF: fielderS.isOn)
        }
    }
    @IBAction func onClickExchange(_ sender: Any) {
        viewModel?.isExchanging = true
        exchangeB.isEnabled = false
        cancelB.isEnabled = true
        titleL.text = "入れ替える控えを2つ選択してください"
        titleL.textColor = .red
        
        setBottomButtonsEnabled(false)
    }
    @IBAction func onClickAdd(_ sender: Any) {
        viewModel?.addNumOfSub()
    }
    @IBAction func onClickDelete(_ sender: Any) {
        viewModel?.isDeleting = true
        titleL.text = "削除する選手を選択してください"
        titleL.textColor = .red
        cancelB.isEnabled = true
    }
    @IBAction func onClickExchangeWithStarting(_ sender: Any) {
        parentViewModel?.isExchangingStartingSub = true
        exchangeB.isEnabled = false
        cancelB.isEnabled = true
        titleL.text = "スタメンと入れ替える控えを選択してください"
        titleL.textColor = .red
    }
    
    @IBOutlet weak var bannerAD: GADBannerView!
    
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
        nameTF.delegate = self
        viewModel?.delegate = self
        setDefaultUIState()
        
        bannerAD.adUnitID = Constants.BANNER_ID
        bannerAD.rootViewController = self
    }
    
    override func loadBannerAd() {
        bannerAD.adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(getViewWidth())
        bannerAD.load(GADRequest())
    }
    
    func setDefaultUIState() {
        nameTF.placeholder = "控えを選択してください"
        subL.textColor = .gray
        nameTF.text = Constants.EMPTY
        titleL.text = "Sub Member"
        titleL.textColor = .cyan
        pitcherS.setOn(false, animated: true)
        hitterS.setOn(false, animated: true)
        runnerS.setOn(false, animated: true)
        fielderS.setOn(false, animated: true)
        setItemsDefaultEnabled(false)
        
        // MARK: should separate this function within here??
        viewModel?.setDefault()
    }
    
    func setItemsDefaultEnabled(_ isInput: Bool) {
        nameTF.isEnabled = isInput
        pitcherS.isEnabled = isInput
        hitterS.isEnabled = isInput
        runnerS.isEnabled = isInput
        fielderS.isEnabled = isInput
        cancelB.isEnabled = isInput
        registerB.isEnabled = isInput
        exchangeB.isEnabled = !isInput
        setBottomButtonsEnabled(!isInput)
    }
    
    func setBottomButtonsEnabled(_ isInput: Bool) {
        addB.isEnabled = isInput
        deleteB.isEnabled = isInput
        exchangeWithStartingB.isEnabled = isInput
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
        subTableCell.selectionStyle = .none
        subTableCell.viewModel = self.viewModel
        subTableCell.parentViewModel = self.parentViewModel
        subTableCell.tableIndex = indexPath.row
        
        // MARK: Although it is not good to use "if" in View Controller, in this cace, 2 View Model are used,,,,,
        if parentViewModel!.isExchangingStartingSub {
            subTableCell.subButton.backgroundColor = parentViewModel!.getSubButtonColor(index: indexPath.row)
        } else {
            subTableCell.subButton.backgroundColor = viewModel!.getNumButtonColor(index: indexPath.row)
        }
        
        subTableCell.subButton.layer.cornerRadius = 15
        subTableCell.subButton.layer.borderColor = UIColor.black.cgColor
        subTableCell.subButton.layer.borderWidth = 2
        
        let player = viewModel!.getSubPlayer(index: indexPath.row)
        designRoleLabel(uiLabel: subTableCell.pitcherLabel,
                        isOn: player.isPitcher.convertToBool(),
                        color: UIColor.pitcherRoleColor)
        designRoleLabel(uiLabel: subTableCell.hitterLabel,
                        isOn: player.isHitter.convertToBool(),
                        color: UIColor.hitterRoleColor)
        designRoleLabel(uiLabel: subTableCell.runnerLabel,
                        isOn: player.isRunner.convertToBool(),
                        color: UIColor.runnerRoleColor)
        designRoleLabel(uiLabel: subTableCell.fielderLabel,
                        isOn: player.isFielder.convertToBool(),
                        color: UIColor.fielderRoleColor)
        subTableCell.nameText.text = player.name.forDisplay
        
        return subTableCell
    }
    
    func designRoleLabel(uiLabel: UILabel, isOn: Bool, color: UIColor) {
        uiLabel.layer.cornerRadius = 5
        uiLabel.clipsToBounds = true
        uiLabel.layer.borderColor = UIColor.black.cgColor
        uiLabel.layer.borderWidth = 0.7
        
        // MARK: TODO should do within VM,,,?
        if isOn {
            uiLabel.backgroundColor = color
            uiLabel.textColor = .black
        } else {
            uiLabel.backgroundColor = .gray
            uiLabel.textColor = UIColor.offTextColor
        }
    }
}

extension SubMemberViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTF.resignFirstResponder()
        return true
    }
}

extension SubMemberViewController: SubMemberVMDelegate {
    func reloadOrder() {
        subPlayerTable.reloadData()
    }
    
    func setDefaultUI() {
        setDefaultUIState()
    }
    
    func prepareRegistering(selected: Int) {
        setItemsDefaultEnabled(true)
        
        let currentPlayer = viewModel!.getSubPlayer(index: selected)
        nameTF.placeholder = "名前を入力してください"
        subL.textColor = .red
        nameTF.text = currentPlayer.name.original
        pitcherS.setOn(currentPlayer.isPitcher.convertToBool(), animated: true)
        hitterS.setOn(currentPlayer.isHitter.convertToBool(), animated: true)
        runnerS.setOn(currentPlayer.isRunner.convertToBool(), animated: true)
        fielderS.setOn(currentPlayer.isFielder.convertToBool(), animated: true)
        setBottomButtonsEnabled(false)
    }
}
