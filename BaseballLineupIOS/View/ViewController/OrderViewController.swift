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
    @IBOutlet weak var orderTable: UITableView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var exchangeButton: UIButton!
    
    //For All Hitter
    @IBOutlet weak var addOrderButton: UIButton!
    @IBOutlet weak var deleteOrderButton: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bannerAD: GADBannerView!
    
    private let numlabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Constants.NO_NUM
        label.font = UIFont.boldSystemFont(ofSize: 40)
        label.textColor = .blue
        label.textAlignment = .center
        return label
    }()
    
    private let nameTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.backgroundColor = .white
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
        
        let spacer = UIView()
        stackView.addArrangedSubview(numlabel)
        stackView.addArrangedSubview(nameTextField)
        stackView.addArrangedSubview(spacer)
        
        NSLayoutConstraint.activate([
            numlabel.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 8/20),
            nameTextField.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 11/20),
            spacer.heightAnchor.constraint(equalTo: stackView.heightAnchor, multiplier: 1/20),
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
        stackView.backgroundColor = .systemBlue
        
        stackView.addArrangedSubview(UIView())
        stackView.addArrangedSubview(numAndName)
        stackView.addArrangedSubview(positionPicker)
        
        NSLayoutConstraint.activate([
            numAndName.widthAnchor.constraint(equalToConstant: view.frame.size.width * 0.7),
        ])
        
        return stackView
    }()
    
    @IBAction func onClickCancel(_ sender: Any) {
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
    @IBAction func onClickExchange(_ sender: Any) {
        viewModel?.isExchanging = true
        exchangeButton.isEnabled = false
        addOrderButton.isEnabled = false
        deleteOrderButton.isEnabled = false
        cancelButton.isEnabled = true
        titleLabel.text = "入れ替える打順を2つ選択してください"
        titleLabel.textColor = .red
    }
    @IBAction func onClickRegister(_ sender: Any) {
        if viewModel!.isNumSelected() {
            viewModel?.writtenName = nameTextField.text!
            viewModel?.overWriteStatingPlayer()
            orderTable.reloadData()
            setDefaultUIState()
        }
    }
    
    
    @IBAction func onClickAdd(_ sender: Any) {
        guard let vm = viewModel else { return }
        
        vm.addOrder()
        reloadOrder()
        
        if vm.shouldAddDH() {
            positionPicker.reloadAllComponents()
        }
    }
    
    
    @IBAction func onClickDelete(_ sender: Any) {
        guard let vm = viewModel else { return }
        
        vm.deleteOrder()
        reloadOrder()
        
        if vm.shouldRemoveDH() {
            positionPicker.reloadAllComponents()
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
        viewModel = .init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        viewModel?.fetchData()
//        orderTable.dataSource = self
        viewModel?.delegate = self
        
        
        
        nameTextField.delegate = self
        positionPicker.delegate = self
        setDefaultUIState()
        
//        bannerAD.adUnitID = Constants.BANNER_ID
//        bannerAD.rootViewController = self
        
        if viewModel?.orderType == .Special {
//            cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        } else {
//            addOrderButton.isHidden = true
//            deleteOrderButton.isHidden = true
        }
    }
    
    private func setupView() {
        view.addSubview(registeringStack)
        
        NSLayoutConstraint.activate([
            registeringStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            registeringStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            registeringStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            registeringStack.heightAnchor.constraint(equalToConstant: 90),
        ])
        
        view.backgroundColor = .green
    }
    
    override func loadBannerAd() {
//        bannerAD.adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(getViewWidth())
//        bannerAD.load(GADRequest())
    }
    
    func setDefaultUIState() {
        numlabel.text = Constants.NO_NUM
        positionPicker.selectRow(Position.Non.indexForOrder, inComponent: 0, animated: true)
        nameTextField.text = Constants.EMPTY
        setItemsEnabled(false)
        nameTextField.placeholder = "打順を選択してください"
//        titleLabel.text = "Starting Member"
//        titleLabel.textColor = .green
        
        // MARK: should separate this function within here??
        viewModel?.resetData()
    }
    
    func setItemsEnabled(_ isInput: Bool) {
        positionPicker.isUserInteractionEnabled = isInput
        nameTextField.isEnabled = isInput
//        cancelButton.isEnabled = isInput
//        registerButton.isEnabled = isInput
//        exchangeButton.isEnabled = !isInput
//        addOrderButton.isEnabled = !isInput
//        deleteOrderButton.isEnabled = !isInput
    }
    
    func prepareToExchangeWithSub() {
        setDefaultUIState()
        reloadOrder()
        exchangeButton.isEnabled = false
        addOrderButton.isEnabled = false
        deleteOrderButton.isEnabled = false
        cancelButton.isEnabled = true
        titleLabel.text = "控えと入れ替える打順を選択してください"
        titleLabel.textColor = .red
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
        guard let orderTableCell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath) as? OrderTableCell else {
            fatalError("Could not create ReviewCell")
        }
        orderTableCell.selectionStyle = .none
        orderTableCell.orderVM = self.viewModel
        orderTableCell.parentViewModel = self.parentViewModel
        
        let orderNum = OrderNum(order: indexPath.row + 1)
        guard let startingPlayer = viewModel?.getStatingPlayer(num: orderNum) else { return orderTableCell }
        orderTableCell.orderNum = orderNum
        orderTableCell.numButton.setTitle(viewModel!.getNumButtonText(orderNum: orderNum), for: .normal)
        orderTableCell.numButton.backgroundColor = viewModel!.getNumButtonColor(orderNum: orderNum)
        orderTableCell.numButton.layer.cornerRadius = 15
        orderTableCell.numButton.layer.borderColor = UIColor.black.cgColor
        orderTableCell.numButton.layer.borderWidth = 2
        orderTableCell.positionLabel.text = "(\(startingPlayer.position.description))"
        orderTableCell.nameLabel.text = "\(startingPlayer.name.forDisplay)"
        
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
        let currentPlayer = viewModel!.getStatingPlayer(num: selectedNum)
        
        numlabel.text = viewModel?.getNumButtonText(orderNum: selectedNum)
        viewModel?.selectedPosition = currentPlayer.position
        setItemsEnabled(true)
        if viewModel!.isDHPitcher(orderNum: selectedNum) {
            positionPicker.selectRow(Position.Pitcher.indexForOrder, inComponent: 0, animated: true)
            positionPicker.isUserInteractionEnabled = false
            viewModel?.selectedPosition = Position(description: Constants.POSITIONS[Position.Pitcher.indexForOrder])
        } else {
            positionPicker.selectRow(currentPlayer.position.indexForOrder, inComponent: 0, animated: true)
            positionPicker.isUserInteractionEnabled = true
        }
        
        nameTextField.placeholder = "名前を入力してください"
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
        pickerLabel.font = UIFont(name:"Helvetica", size: 26)
        pickerLabel.textAlignment = .center
        pickerLabel.text = Constants.POSITIONS[row]
        
        return pickerLabel
    }
}
