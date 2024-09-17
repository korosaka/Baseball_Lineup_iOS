//
//  FieldViewController.swift
//  BaseballLineupIOS
//
//  Created by Koro Saka on 2020-12-07.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import UIKit
import GoogleMobileAds
class FieldViewController: BaseADViewController {
    var viewModel: FieldViewModel?
    
    private var nameLabels = [UILabel]()
    private var orderNumLabels = [UILabel]()
    private var isOnSquare: Bool?
    private let defaultTextSize = 22.0
    
    private lazy var centerNum: UILabel = {
        return createLabel()
    }()
    
    private lazy var centerName: UILabel = {
        return createLabel()
    }()
    
    private lazy var centerStack: UIStackView = {
        return createPlayerStack(centerNum, centerName)
    }()
    
    private lazy var leftNum: UILabel = {
        return createLabel()
    }()
    
    private lazy var leftName: UILabel = {
        return createLabel()
    }()
    
    private lazy var leftStack: UIStackView = {
        return createPlayerStack(leftNum, leftName)
    }()
    
    private lazy var rightNum: UILabel = {
        return createLabel()
    }()
    
    private lazy var rightName: UILabel = {
        return createLabel()
    }()
    
    private lazy var rightStack: UIStackView = {
        return createPlayerStack(rightNum, rightName)
    }()
    
    private lazy var shortNum: UILabel = {
        return createLabel()
    }()
    
    private lazy var shortName: UILabel = {
        return createLabel()
    }()
    
    private lazy var shortStack: UIStackView = {
        return createPlayerStack(shortNum, shortName)
    }()
    
    private lazy var secondNum: UILabel = {
        return createLabel()
    }()
    
    private lazy var secondName: UILabel = {
        return createLabel()
    }()
    
    private lazy var secondStack: UIStackView = {
        return createPlayerStack(secondNum, secondName)
    }()
    
    private lazy var thirdNum: UILabel = {
        return createLabel()
    }()
    
    private lazy var thirdName: UILabel = {
        return createLabel()
    }()
    
    private lazy var thirdStack: UIStackView = {
        return createPlayerStack(thirdNum, thirdName)
    }()
    
    private lazy var firstNum: UILabel = {
        return createLabel()
    }()
    
    private lazy var firstName: UILabel = {
        return createLabel()
    }()
    
    private lazy var firstStack: UIStackView = {
        return createPlayerStack(firstNum, firstName)
    }()
    
    private lazy var pitcherNum: UILabel = {
        return createLabel()
    }()
    
    private lazy var pitcherName: UILabel = {
        return createLabel()
    }()
    
    private lazy var pitcherStack: UIStackView = {
        return createPlayerStack(pitcherNum, pitcherName)
    }()
    
    private lazy var dh4Num: UILabel = {
        return createLabel()
    }()
    
    private lazy var dh4Name: UILabel = {
        return createLabel()
    }()
    
    private lazy var dh4Stack: UIStackView = {
        return createPlayerStack(dh4Num, dh4Name, isDH: true)
    }()
    
    private lazy var dh1Num: UILabel = {
        return createLabel()
    }()
    
    private lazy var dh1Name: UILabel = {
        return createLabel()
    }()
    
    private lazy var dh1Stack: UIStackView = {
        return createPlayerStack(dh1Num, dh1Name, isDH: true)
    }()
    
    private lazy var dh5Num: UILabel = {
        return createLabel()
    }()
    
    private lazy var dh5Name: UILabel = {
        return createLabel()
    }()
    
    private lazy var dh5Stack: UIStackView = {
        return createPlayerStack(dh5Num, dh5Name, isDH: true)
    }()
    
    private lazy var dh2Num: UILabel = {
        return createLabel()
    }()
    
    private lazy var dh2Name: UILabel = {
        return createLabel()
    }()
    
    private lazy var dh2Stack: UIStackView = {
        return createPlayerStack(dh2Num, dh2Name, isDH: true)
    }()
    
    private lazy var dh6Num: UILabel = {
        return createLabel()
    }()
    
    private lazy var dh6Name: UILabel = {
        return createLabel()
    }()
    
    private lazy var dh6Stack: UIStackView = {
        return createPlayerStack(dh6Num, dh6Name, isDH: true)
    }()
    
    private lazy var dh3Num: UILabel = {
        return createLabel()
    }()
    
    private lazy var dh3Name: UILabel = {
        return createLabel()
    }()
    
    private lazy var dh3Stack: UIStackView = {
        return createPlayerStack(dh3Num, dh3Name, isDH: true)
    }()
    
    private lazy var catcherNum: UILabel = {
        return createLabel()
    }()
    
    private lazy var catcherName: UILabel = {
        return createLabel()
    }()
    
    private lazy var catcherStack: UIStackView = {
        return createPlayerStack(catcherNum, catcherName)
    }()
    
    private func createLabel() -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: defaultTextSize)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }
    
    private func createPlayerStack(_ orderNum: UILabel, _ playerName: UILabel, isDH: Bool = false) -> UIStackView {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.isHidden = isDH
        
        let spacer = UIView()
        stackView.addArrangedSubview(orderNum)
        stackView.addArrangedSubview(spacer)
        stackView.addArrangedSubview(playerName)
        
        NSLayoutConstraint.activate([
            orderNum.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 20/100),
            spacer.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 1/100),
            playerName.widthAnchor.constraint(equalTo: stackView.widthAnchor, multiplier: 79/100),
        ])
        
        return stackView
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: Bundle!) {
        super.init(nibName: nil, bundle: nil)
        setup()
    }
    
    convenience init(isOnSquare: Bool = false) {
        self.init(nibName: nil, bundle: nil)
        self.isOnSquare = isOnSquare
    }
    
    func setup() {
        viewModel = .init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        putUILabelsIntoArray()
        customNameLabelDesign()
        customNumLabelDesign()
    }
    
    private func setupView() {
        let backgroundImage = UIImage(named: "field_image")
        let backgroundImageView = UIImageView(image: backgroundImage)
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.clipsToBounds = true
        backgroundImageView.contentMode = .scaleAspectFill
        view.addSubview(backgroundImageView)
        addPlayerStack(pitcherStack)
        addPlayerStack(catcherStack)
        addPlayerStack(firstStack)
        addPlayerStack(secondStack)
        addPlayerStack(thirdStack)
        addPlayerStack(shortStack)
        addPlayerStack(leftStack)
        addPlayerStack(centerStack)
        addPlayerStack(rightStack)
        addPlayerStack(dh1Stack)
        addPlayerStack(dh2Stack)
        addPlayerStack(dh3Stack)
        addPlayerStack(dh4Stack)
        addPlayerStack(dh5Stack)
        addPlayerStack(dh6Stack)
        view.addSubview(bannerAD)
        
        let playerStackHeight = 30.0
        let playerStackWidth = 160.0
        let viewHeight = view.frame.size.height
        let viewWidth = view.frame.size.width
        var baseCalcSize = viewHeight
        if isOnSquare == true {
            baseCalcSize = viewWidth * 0.9
        }
        let spaceAboveCenter = baseCalcSize * 0.02
        let spaceBottomCenter = baseCalcSize * 0.05
        let spaceBottomLeftRight = baseCalcSize * 0.08
        let spaceBottomShortSecond = baseCalcSize * 0.05
        let spaceAbovePitcher = baseCalcSize * 0.02
        let spaceBottomCatcher = baseCalcSize * -0.03
        let spaceAboveCatcher = baseCalcSize * -0.02
        let spaceDH = -1.0
        let spaceAd = -3.0
        let adjustmentForCenterX = -15.0
        
        let leftEdge = 2.0
        let rightEdge = -5.0
        let shortEdge = 15.0
        let secondEdge = -18.0
        
        NSLayoutConstraint.activate([
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            centerStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: spaceAboveCenter),
            centerStack.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: adjustmentForCenterX),
            leftStack.topAnchor.constraint(equalTo: centerStack.bottomAnchor, constant: spaceBottomCenter),
            leftStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: leftEdge),
            rightStack.topAnchor.constraint(equalTo: centerStack.bottomAnchor, constant: spaceBottomCenter),
            rightStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: rightEdge),
            shortStack.topAnchor.constraint(equalTo: leftStack.bottomAnchor, constant: spaceBottomLeftRight),
            shortStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: shortEdge),
            secondStack.topAnchor.constraint(equalTo: rightStack.bottomAnchor, constant: spaceBottomLeftRight),
            secondStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: secondEdge),
            thirdStack.topAnchor.constraint(equalTo: shortStack.bottomAnchor, constant: spaceBottomShortSecond),
            thirdStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: leftEdge),
            firstStack.topAnchor.constraint(equalTo: secondStack.bottomAnchor, constant: spaceBottomShortSecond),
            firstStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: rightEdge),
            pitcherStack.topAnchor.constraint(equalTo: thirdStack.bottomAnchor, constant: spaceAbovePitcher),
            pitcherStack.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: adjustmentForCenterX),
            dh4Stack.bottomAnchor.constraint(equalTo: dh5Stack.topAnchor, constant: spaceDH),
            dh4Stack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: leftEdge),
            dh1Stack.bottomAnchor.constraint(equalTo: dh2Stack.topAnchor, constant: spaceDH),
            dh1Stack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: rightEdge),
            dh5Stack.bottomAnchor.constraint(equalTo: dh6Stack.topAnchor, constant: spaceDH),
            dh5Stack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: leftEdge),
            dh2Stack.bottomAnchor.constraint(equalTo: dh3Stack.topAnchor, constant: spaceDH),
            dh2Stack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: rightEdge),
            dh6Stack.bottomAnchor.constraint(equalTo: catcherStack.topAnchor, constant: spaceAboveCatcher),
            dh6Stack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: leftEdge),
            dh3Stack.bottomAnchor.constraint(equalTo: catcherStack.topAnchor, constant: spaceAboveCatcher),
            dh3Stack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: rightEdge),
            catcherStack.bottomAnchor.constraint(equalTo: bannerAD.topAnchor, constant: spaceBottomCatcher),
            catcherStack.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: adjustmentForCenterX),
            bannerAD.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bannerAD.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: spaceAd),
        ])
        
        playerStacks.forEach {
            $0.heightAnchor.constraint(equalToConstant: playerStackHeight).isActive = true
            $0.widthAnchor.constraint(equalToConstant: playerStackWidth).isActive = true
        }
    }
    
    private var playerStacks = [UIStackView]()
    
    private func addPlayerStack(_ stackView: UIStackView) {
        view.addSubview(stackView)
        playerStacks.append(stackView)
    }
    
    private func showHideDHLabels(_ orderType: OrderType) {
        switch orderType {
        case .Normal:
            return
        case .DH:
            dh1Stack.isHidden = false
        case .Special:
            guard let playersCount = viewModel?.getPlayersCount() else { return }
            let dhIndexRange = FieldViewModel.PositionInField.DH1.index...FieldViewModel.PositionInField.DH6.index
            for dhIndex in dhIndexRange {
                let isAvailableIndex = dhIndex < playersCount
                playerStacks[dhIndex].isHidden = !isAvailableIndex
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareForAppear()
    }
    
    func prepareForAppear() {
        guard let orderType = viewModel?.orderType else {
            return
        }
        
        viewModel?.loadOrderInfo()
        showHideDHLabels(orderType)
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
        nameLabels.append(dh2Name)
        nameLabels.append(dh3Name)
        nameLabels.append(dh4Name)
        nameLabels.append(dh5Name)
        nameLabels.append(dh6Name)
        
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
        orderNumLabels.append(dh2Num)
        orderNumLabels.append(dh3Num)
        orderNumLabels.append(dh4Num)
        orderNumLabels.append(dh5Num)
        orderNumLabels.append(dh6Num)
    }
    
    private func customNameLabelDesign() {
        guard let vm = viewModel else { return }
        let radiusValue = CGFloat(10.0)
        let borderWith = CGFloat(2.0)
        
        for index in 0..<nameLabels.count {
            let label = nameLabels[index]
            label.clipsToBounds = true
            label.layer.cornerRadius = radiusValue
            label.layer.borderWidth = borderWith
            label.layer.borderColor = vm.getNameBorderColor(index).cgColor
            label.backgroundColor = vm.getNameLabelColor(index)
        }
    }
    
    private func customNumLabelDesign() {
        let radiusValue = CGFloat(10.0)
        let borderWith = CGFloat(2.0)
        let borderColor = UIColor.orderNumBorderColor.cgColor
        
        orderNumLabels.forEach { numLabel in
            numLabel.clipsToBounds = true
            numLabel.layer.cornerRadius = radiusValue
            numLabel.layer.borderWidth = borderWith
            numLabel.layer.borderColor = borderColor
            numLabel.backgroundColor = UIColor.orderNumColor
        }
    }
    
    private func displayOrder() {
        guard let vm = viewModel else { return }
        for index in 0..<vm.getPlayersCount() {
            let name = vm.getPlayerName(index)
            let defaultTextCount = 5
            var textSize = defaultTextSize
            if name.count > defaultTextCount {
                textSize = Double(Int(defaultTextSize) * defaultTextCount / name.count)
            }
            nameLabels[index].font = UIFont.boldSystemFont(ofSize: CGFloat(textSize))
            nameLabels[index].text = name
            orderNumLabels[index].text = vm.getOrderNum(index)
        }
    }
}
