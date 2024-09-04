//
//  OrderViewController.swift
//  BaseballLineupIOS
//
//  Created by Koro Saka on 2020-11-11.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import UIKit
import GoogleMobileAds

class OrderViewController: BaseADViewController {
    
    var viewModel: OrderViewModel?
    var parentViewModel: CustomTabBarViewModel?
    
    private let numlabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Constants.NO_NUM
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private let nameTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.backgroundColor = UIColor.dynamicColor(light: .white, dark: .textFieldDarkColor)
        tf.layer.cornerRadius = 6
        tf.textColor = .black
        tf.attributedPlaceholder = NSAttributedString(string: Constants.SELECT_ORDER_NUM,
                                                      attributes: [NSAttributedString.Key.foregroundColor: UIColor.dynamicColor(light: .lightGray, dark: .gray)])
        tf.font = UIFont.boldSystemFont(ofSize: 16)
        tf.clearButtonMode = .always
        return tf
    }()
    
    private let positionPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private lazy var numAndName: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        
        let spacer1 = UIView()
        let spacer2 = UIView()
        let spacer3 = UIView()
        stackView.addArrangedSubview(spacer1)
        stackView.addArrangedSubview(numlabel)
        stackView.addArrangedSubview(spacer2)
        stackView.addArrangedSubview(nameTextField)
        stackView.addArrangedSubview(spacer3)
        
        NSLayoutConstraint.activate([
            spacer1.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 1/20),
            numlabel.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 8/20),
            spacer2.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 1/20),
            nameTextField.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 9/20),
            spacer3.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 1/20),
        ])
        
        return stackView
    }()
    
    private lazy var registeringStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 5
        stackView.backgroundColor = UIColor.dynamicColor(light: .registeringBoxLightColor, dark: .registeringBoxDarkColor)
        
        stackView.addArrangedSubview(UIView())
        stackView.addArrangedSubview(numAndName)
        stackView.addArrangedSubview(positionPicker)
        stackView.layer.cornerRadius = 6
        
        NSLayoutConstraint.activate([
            numAndName.widthAnchor.constraint(equalToConstant: view.frame.size.width * 0.6),
        ])
        
        return stackView
    }()
    
    private lazy var cancelButton: UIButton = {
        return createOperationButton(title: "キャンセル")
    }()
    
    private lazy var registerButton: UIButton = {
        return createOperationButton(title: "登録")
    }()
    
    private lazy var exchangeButton: UIButton = {
        return createOperationButton(title: "入替")
    }()
    
    private lazy var addOrderButton: UIButton = {
        return createOperationButton(title: "追加")
    }()
    
    private lazy var deleteOrderButton: UIButton = {
        return createOperationButton(title: "削除")
    }()
    
    private lazy var clearDataButton: UIButton = {
        let button = createOperationButton(title: "全削除")
        button.backgroundColor = .red
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
    
    private lazy var operationButtonsStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 5
        stackView.addArrangedSubview(cancelButton)
        stackView.addArrangedSubview(registerButton)
        stackView.addArrangedSubview(exchangeButton)
        stackView.addArrangedSubview(addOrderButton)
        stackView.addArrangedSubview(deleteOrderButton)
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Starting Member"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()
    
    private let cellIdentifier = "OrderCell"
    
    private lazy var orderTable: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(OrderTableCell.self, forCellReuseIdentifier: cellIdentifier)
        table.layer.cornerRadius = 8
        table.backgroundColor = .white
        return table
    }()
    
    @objc private func onClickCancel(_ sender: UIButton) {
        guard let _parentVM = parentViewModel else { return print("error happened!") }
        if _parentVM.isExchangingStartingSub {
            _parentVM.resetData()
            _parentVM.reloadTables()
            _parentVM.resetUI()
        } else {
            setDefaultUIState()
            // MARK: to back num button color
            reloadOrder()
        }
    }
    
    @objc private func onClickExchange(_ sender: UIButton) {
        viewModel?.isExchanging = true
        switchCancelB(true)
        switchRegisterB(false)
        switchExchangeB(false)
        switchAddOrderB(false)
        switchDeleteOrderB(false)
        titleLabel.text = "入れ替える打順を2つ選択してください"
        titleLabel.textColor = .red
    }
    
    @objc private func onClickRegister(_ sender: UIButton) {
        guard let vm = viewModel, let text = nameTextField.text else { return }
        if vm.isNumSelected() {
            vm.writtenName = text
            vm.overWriteStatingPlayer()
            orderTable.reloadData()
            setDefaultUIState()
        }
    }
    
    
    @objc private func onClickAdd(_ sender: UIButton) {
        guard let vm = viewModel else { return }
        
        vm.addOrder()
        reloadOrder()
        
        if vm.shouldAddDH() {
            positionPicker.reloadAllComponents()
        }
    }
    
    
    @objc private func onClickDelete(_ sender: UIButton) {
        guard let vm = viewModel else { return }
        
        vm.deleteOrder()
        reloadOrder()
        
        if vm.shouldRemoveDH() {
            positionPicker.reloadAllComponents()
        }
    }
    
    @objc private func onClickAllClear(_ sender: UIButton) {
        guard let vm = viewModel else { return }
        
        let alertDialog = UIAlertController(title: Constants.CLEAR_ALL,
                                            message: Constants.SURE_FOR_ALL_CLEAR,
                                            preferredStyle: UIAlertController.Style.alert)
        alertDialog.addAction(UIAlertAction(title: Constants.OK, style:UIAlertAction.Style.default){
            (action:UIAlertAction)in
            vm.allClearData()
            self.reloadOrder()
        })
        alertDialog.addAction(UIAlertAction(title: Constants.TITLE_CANCEL, style:UIAlertAction.Style.cancel, handler: nil))
        present(alertDialog, animated: true, completion:nil)
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
        viewModel?.fetchData()
        orderTable.dataSource = self
        viewModel?.delegate = self
        nameTextField.delegate = self
        positionPicker.delegate = self
        setDefaultUIState()
        
        if viewModel?.orderType == .Special {
            cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        } else {
            addOrderButton.isHidden = true
            deleteOrderButton.isHidden = true
        }
    }
    
    private func setupView() {
        view.backgroundColor = .appBackGroundColor
        view.addSubview(registeringStack)
        view.addSubview(operationButtonsStack)
        view.addSubview(titleLabel)
        view.addSubview(orderTable)
        view.addSubview(clearDataButton)
        view.addSubview(bannerAD)
        cancelButton.addTarget(self, action: #selector(onClickCancel), for: .touchUpInside)
        registerButton.addTarget(self, action: #selector(onClickRegister), for: .touchUpInside)
        exchangeButton.addTarget(self, action: #selector(onClickExchange), for: .touchUpInside)
        addOrderButton.addTarget(self, action: #selector(onClickAdd), for: .touchUpInside)
        deleteOrderButton.addTarget(self, action: #selector(onClickDelete), for: .touchUpInside)
        clearDataButton.addTarget(self, action: #selector(onClickAllClear), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            registeringStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            registeringStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 2),
            registeringStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -2),
            registeringStack.heightAnchor.constraint(equalToConstant: 100),
            operationButtonsStack.topAnchor.constraint(equalTo: registeringStack.bottomAnchor, constant: 15),
            operationButtonsStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 5),
            operationButtonsStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -5),
            operationButtonsStack.heightAnchor.constraint(equalToConstant: 40),
            titleLabel.topAnchor.constraint(equalTo: operationButtonsStack.bottomAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            orderTable.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 3),
            orderTable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 5),
            orderTable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -5),
            clearDataButton.topAnchor.constraint(equalTo: orderTable.bottomAnchor, constant: 3),
            clearDataButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -5),
            clearDataButton.bottomAnchor.constraint(equalTo: bannerAD.topAnchor, constant: -5),
            clearDataButton.widthAnchor.constraint(equalToConstant: 100),
            bannerAD.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bannerAD.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -3),
        ])
    }
    
    func setDefaultUIState() {
        numlabel.text = Constants.NO_NUM
        positionPicker.selectRow(Position.Non.indexForOrder, inComponent: 0, animated: true)
        nameTextField.text = Constants.EMPTY
        setItemsEnabled(false)
        nameTextField.placeholder = Constants.SELECT_ORDER_NUM
        titleLabel.text = "Starting Member"
        titleLabel.textColor = .registeringBoxLightColor
        
        // MARK: should separate this function within here??
        viewModel?.resetData()
    }
    
    func setItemsEnabled(_ isInput: Bool) {
        positionPicker.isUserInteractionEnabled = isInput
        nameTextField.isEnabled = isInput
        switchCancelB(isInput)
        switchRegisterB(isInput)
        switchExchangeB(!isInput)
        switchAddOrderB(!isInput)
        switchDeleteOrderB(!isInput)
    }
    
    func prepareToExchangeWithSub() {
        setDefaultUIState()
        reloadOrder()
        switchRegisterB(false)
        switchExchangeB(false)
        switchAddOrderB(false)
        switchDeleteOrderB(false)
        switchCancelB(true)
        titleLabel.text = "控えと入れ替える打順を選択してください"
        titleLabel.textColor = .red
    }
    
    private func switchCancelB(_ isEnabled: Bool) {
        cancelButton.setAvailability(isEnabled: isEnabled, backgroundColor: .operationButtonColor)
    }
    
    private func switchRegisterB(_ isEnabled: Bool) {
        registerButton.setAvailability(isEnabled: isEnabled, backgroundColor: .operationButtonColor)
    }
    
    private func switchExchangeB(_ isEnabled: Bool) {
        exchangeButton.setAvailability(isEnabled: isEnabled, backgroundColor: .operationButtonColor)
    }
    
    private func switchAddOrderB(_ isEnabled: Bool) {
        addOrderButton.setAvailability(isEnabled: isEnabled, backgroundColor: .operationButtonColor)
    }
    
    private func switchDeleteOrderB(_ isEnabled: Bool) {
        deleteOrderButton.setAvailability(isEnabled: isEnabled, backgroundColor: .operationButtonColor)
    }
}

extension OrderViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let tableSize = viewModel?.getOrdeSize() else {
            return 0
        }
        return tableSize
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let orderTableCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? OrderTableCell else {
            fatalError("Could not create ReviewCell")
        }
        orderTableCell.selectionStyle = .none
        orderTableCell.orderVM = self.viewModel
        orderTableCell.parentViewModel = self.parentViewModel
        
        let orderNum = OrderNum(order: indexPath.row + 1)
        guard let vm = viewModel else { return orderTableCell }
        let startingPlayer = vm.getStatingPlayer(num: orderNum)
        orderTableCell.orderNum = orderNum
        orderTableCell.numButton.setTitle(vm.getNumButtonText(orderNum: orderNum), for: .normal)
        orderTableCell.numButton.backgroundColor = vm.getNumButtonColor(orderNum: orderNum)
        orderTableCell.numButton.addNumButtonDesign()
        orderTableCell.positionLabel.text = "(\(startingPlayer.position.description))"
        
        let name = startingPlayer.name.forDisplay
        let defaultTextSize = 24.0
        let defaultTextCount = 7
        var textSize = defaultTextSize
        if name.count > defaultTextCount {
            textSize = Double(Int(defaultTextSize) * defaultTextCount / name.count)
        }
        orderTableCell.nameLabel.font = UIFont.boldSystemFont(ofSize: CGFloat(textSize))
        orderTableCell.nameLabel.text = name
        
        return orderTableCell
    }
}

extension OrderViewController: OrderVMDelegate {
    
    func reloadOrder() {
        orderTable.reloadData()
    }
    
    func setUIDefault() {
        setDefaultUIState()
    }
    
    func prepareRegistering(selectedNum: OrderNum) {
        guard let vm = viewModel else { return }
        let currentPlayer = vm.getStatingPlayer(num: selectedNum)
        
        numlabel.text = vm.getNumButtonText(orderNum: selectedNum)
        vm.selectedPosition = currentPlayer.position
        setItemsEnabled(true)
        if vm.isDHPitcher(orderNum: selectedNum) {
            positionPicker.selectRow(Position.Pitcher.indexForOrder, inComponent: 0, animated: true)
            positionPicker.isUserInteractionEnabled = false
            viewModel?.selectedPosition = Position(description: Constants.POSITIONS[Position.Pitcher.indexForOrder])
        } else {
            positionPicker.selectRow(currentPlayer.position.indexForOrder, inComponent: 0, animated: true)
            positionPicker.isUserInteractionEnabled = true
        }
        
        nameTextField.placeholder = "ここに名前を入力してください"
        nameTextField.text = currentPlayer.name.original
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
        guard let num = viewModel?.getPickerNum() else {
            return 0
        }
        return num
    }
    
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        guard let vm = viewModel else { return }
        // MARK: prevent set position P to fielder in DH
        if (vm.isHitterWhenDH()) && (row == Position.Pitcher.indexForOrder) {
            vm.selectedPosition = Position(description: Constants.POSITIONS[Position.Non.indexForOrder])
            pickerView.selectRow(Position.Non.indexForOrder, inComponent: 0, animated: true)
            return
        }
        vm.selectedPosition = Position(description: Constants.POSITIONS[row])
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let pickerLabel = UILabel()
        pickerLabel.font = UIFont.boldSystemFont(ofSize: 26)
        pickerLabel.textAlignment = .center
        pickerLabel.text = Constants.POSITIONS[row]
        pickerLabel.textColor = .pickerColor
        
        return pickerLabel
    }
}
