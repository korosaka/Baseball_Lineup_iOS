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
    
    private let subL: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textColor = .white
        label.text = "控え"
        label.textAlignment = .center
        return label
    }()
    
    private let nameTF: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.backgroundColor = .white
        tf.font = UIFont.boldSystemFont(ofSize: 16)
        tf.layer.cornerRadius = 6
        tf.textColor = .black
        tf.attributedPlaceholder = NSAttributedString(string: Constants.SELECT_SUB,
                                                             attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        return tf
    }()
    
    private lazy var labelAndTF: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        
        let spacer = UIView()
        stackView.addArrangedSubview(subL)
        stackView.addArrangedSubview(nameTF)
        stackView.addArrangedSubview(spacer)
        
        NSLayoutConstraint.activate([
            subL.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 9/20),
            nameTF.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 10/20),
            spacer.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 1/20),
        ])
        
        return stackView
    }()
    
    private let pitcherS: UISwitch = {
        let pSwitch = UISwitch()
        pSwitch.translatesAutoresizingMaskIntoConstraints = false
        return pSwitch
    }()
    
    private let hitterS: UISwitch = {
        let pSwitch = UISwitch()
        pSwitch.translatesAutoresizingMaskIntoConstraints = false
        return pSwitch
    }()
    
    private let runnerS: UISwitch = {
        let pSwitch = UISwitch()
        pSwitch.translatesAutoresizingMaskIntoConstraints = false
        return pSwitch
    }()
    
    private let fielderS: UISwitch = {
        let pSwitch = UISwitch()
        pSwitch.translatesAutoresizingMaskIntoConstraints = false
        return pSwitch
    }()
    
    private lazy var pitcherAndRuunerStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.addArrangedSubview(createRoleSwitch("投", pitcherS))
        stackView.addArrangedSubview(createRoleSwitch("走", runnerS))
        return stackView
    }()
    
    private lazy var hitterAndfielderStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.addArrangedSubview(createRoleSwitch("打", hitterS))
        stackView.addArrangedSubview(createRoleSwitch("守", fielderS))
        return stackView
    }()
    
    private func createRoleSwitch(_ text: String, _ uiSwitch: UISwitch) -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        
        let label = UILabel()
        label.text = text
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 16)
        
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(uiSwitch)
        
        return stackView
    }
    
    private lazy var registeringStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 0
        stackView.backgroundColor = .registeringBoxColor
        stackView.layer.cornerRadius = 6
        
        let spacer = UIView()
        stackView.addArrangedSubview(spacer)
        stackView.addArrangedSubview(labelAndTF)
        stackView.addArrangedSubview(pitcherAndRuunerStack)
        stackView.addArrangedSubview(hitterAndfielderStack)
        
        NSLayoutConstraint.activate([
            labelAndTF.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 1/100),
            labelAndTF.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 55/100),
            pitcherAndRuunerStack.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 22/100),
            hitterAndfielderStack.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 22/100),
        ])
        
        return stackView
    }()
    
    private lazy var cancelB: UIButton = {
        let button = createOperationButton(title: "キャンセル")
        button.addTarget(self, action: #selector(onClickCancel), for: .touchUpInside)
        return button
    }()
    
    private lazy var registerB: UIButton = {
        let button = createOperationButton(title: "登録")
        button.addTarget(self, action: #selector(onClickRegister), for: .touchUpInside)
        return button
    }()
    
    private lazy var exchangeB: UIButton = {
        let button = createOperationButton(title: "入替")
        button.addTarget(self, action: #selector(onClickExchange), for: .touchUpInside)
        return button
    }()
    
    private func createOperationButton(title: String) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title , for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.addOperationButtonDesign()
        return button
    }
    
    private lazy var topOperationButtonsStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 5
        stackView.addArrangedSubview(cancelB)
        stackView.addArrangedSubview(registerB)
        stackView.addArrangedSubview(exchangeB)
        return stackView
    }()
    
    private let titleL: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    
    private let cellIdentifier = "SubPlayerTableCell"
    
    private lazy var subPlayerTable: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(SubPlayerTableCell.self, forCellReuseIdentifier: cellIdentifier)
        table.layer.cornerRadius = 8
        table.backgroundColor = .white
        return table
    }()
    
    private lazy var addB: UIButton = {
        let button = createOperationButton(title: "控え追加")
        button.addTarget(self, action: #selector(onClickAdd), for: .touchUpInside)
        return button
    }()
    
    private lazy var deleteB: UIButton = {
        let button = createOperationButton(title: "控え削除")
        button.addTarget(self, action: #selector(onClickDelete), for: .touchUpInside)
        return button
    }()
    
    private lazy var exchangeWithStartingB: UIButton = {
        let button = createOperationButton(title: "先発入替")
        button.addTarget(self, action: #selector(onClickExchangeWithStarting), for: .touchUpInside)
        return button
    }()
    
    private lazy var bottomOperationButtonsStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 5
        stackView.addArrangedSubview(addB)
        stackView.addArrangedSubview(deleteB)
        stackView.addArrangedSubview(exchangeWithStartingB)
        return stackView
    }()
    
    @objc func onClickCancel(_ sender: Any) {
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
    
    @objc func onClickRegister(_ sender: Any) {
        if viewModel!.isSelected() {
            viewModel!.overWritePlayer(name: nameTF.text!,
                                       isP: pitcherS.isOn,
                                       isH: hitterS.isOn,
                                       isR: runnerS.isOn,
                                       isF: fielderS.isOn)
        }
    }
    
    @objc func onClickExchange(_ sender: Any) {
        viewModel?.isExchanging = true
        switchExchangeB(false)
        switchCancelB(true)
        titleL.text = "入れ替える控えを2つ選択してください"
        titleL.textColor = .red
        
        setBottomButtonsEnabled(false)
    }
    
    @objc func onClickAdd(_ sender: Any) {
        viewModel?.addNumOfSub()
    }
    
    @objc func onClickDelete(_ sender: Any) {
        viewModel?.isDeleting = true
        titleL.text = "削除する選手を選択してください"
        titleL.textColor = .red
        switchCancelB(true)
        switchExchangeB(false)
        switchRegisterB(false)
        setBottomButtonsEnabled(false)
    }
    
    @objc func onClickExchangeWithStarting(_ sender: Any) {
        parentViewModel?.isExchangingStartingSub = true
        switchExchangeB(false)
        switchRegisterB(false)
        switchCancelB(true)
        setBottomButtonsEnabled(false)
        titleL.text = "スタメンと入れ替える控えを選択してください"
        titleL.textColor = .red
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
        setupView()
        subPlayerTable.dataSource = self
        nameTF.delegate = self
        viewModel?.delegate = self
        setDefaultUIState()
    }
    
    private func setupView() {
        view.backgroundColor = .appBackGroundColor
        view.addSubview(registeringStack)
        view.addSubview(topOperationButtonsStack)
        view.addSubview(titleL)
        view.addSubview(subPlayerTable)
        view.addSubview(bottomOperationButtonsStack)
        view.addSubview(bannerAD)
        
        NSLayoutConstraint.activate([
            registeringStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            registeringStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 2),
            registeringStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -2),
            registeringStack.heightAnchor.constraint(equalToConstant: 85),
            topOperationButtonsStack.topAnchor.constraint(equalTo: registeringStack.bottomAnchor, constant: 10),
            topOperationButtonsStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 5),
            topOperationButtonsStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -5),
            topOperationButtonsStack.heightAnchor.constraint(equalToConstant: 40),
            titleL.topAnchor.constraint(equalTo: topOperationButtonsStack.bottomAnchor, constant: 8),
            titleL.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            titleL.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            subPlayerTable.topAnchor.constraint(equalTo: titleL.bottomAnchor, constant: 3),
            subPlayerTable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 5),
            subPlayerTable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -5),
            bottomOperationButtonsStack.topAnchor.constraint(equalTo: subPlayerTable.bottomAnchor, constant: 5),
            bottomOperationButtonsStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 5),
            bottomOperationButtonsStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -5),
            bottomOperationButtonsStack.heightAnchor.constraint(equalToConstant: 35),
            bottomOperationButtonsStack.bottomAnchor.constraint(equalTo: bannerAD.topAnchor, constant: -10),
            bannerAD.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bannerAD.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -3),
        ])
    }
    
    func setDefaultUIState() {
        nameTF.placeholder = Constants.SELECT_SUB
        subL.textColor = .lightGray
        nameTF.text = Constants.EMPTY
        titleL.text = "Sub Member"
        titleL.textColor = .registeringBoxColor
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
        switchCancelB(isInput)
        switchRegisterB(isInput)
        switchExchangeB(!isInput)
        setBottomButtonsEnabled(!isInput)
    }
    
    func setBottomButtonsEnabled(_ isInput: Bool) {
        addB.setAvailability(isEnabled: isInput, backgroundColor: .operationButtonColor)
        deleteB.setAvailability(isEnabled: isInput, backgroundColor: .operationButtonColor)
        exchangeWithStartingB.setAvailability(isEnabled: isInput, backgroundColor: .operationButtonColor)
    }
    
    private func switchCancelB(_ isEnabled: Bool) {
        cancelB.setAvailability(isEnabled: isEnabled, backgroundColor: .operationButtonColor)
    }
    
    private func switchRegisterB(_ isEnabled: Bool) {
        registerB.setAvailability(isEnabled: isEnabled, backgroundColor: .operationButtonColor)
    }
    
    private func switchExchangeB(_ isEnabled: Bool) {
        exchangeB.setAvailability(isEnabled: isEnabled, backgroundColor: .operationButtonColor)
    }
    
}

extension SubMemberViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.getOrdeSize() ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let subTableCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SubPlayerTableCell else {
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
        
        subTableCell.subButton.addNumButtonDesign()
        
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
        
        let name = player.name.forDisplay
        if name.count < 8 {
            subTableCell.nameLabel.font = UIFont.boldSystemFont(ofSize: 24)
        } else if name.count == 8 {
            subTableCell.nameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        } else {
            subTableCell.nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        }
        subTableCell.nameLabel.text = name
        
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
        subL.textColor = .white
        nameTF.text = currentPlayer.name.original
        pitcherS.setOn(currentPlayer.isPitcher.convertToBool(), animated: true)
        hitterS.setOn(currentPlayer.isHitter.convertToBool(), animated: true)
        runnerS.setOn(currentPlayer.isRunner.convertToBool(), animated: true)
        fielderS.setOn(currentPlayer.isFielder.convertToBool(), animated: true)
        setBottomButtonsEnabled(false)
    }
}
