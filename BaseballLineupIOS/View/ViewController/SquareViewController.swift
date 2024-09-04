//
//  SquareViewController.swift
//  BaseballLineupIOS
//
//  Created by 坂公郎 on 2024/07/30.
//  Copyright © 2024 Koro Saka. All rights reserved.
//

import UIKit
class SquareViewController: BaseADViewController {
    
    var viewModel: StartingMemberListViewModel?
    
    private lazy var startingVC: StartingMemberListViewController = {
        let vc = StartingMemberListViewController(isOnSquare: true)
        vc.viewModel?.orderType = viewModel?.orderType
        vc.viewModel?.cacheData = viewModel?.cacheData
        return vc
    }()
    
    private lazy var fieldVC: FieldViewController = {
        let vc = FieldViewController(isOnSquare: true)
        vc.viewModel?.orderType = viewModel?.orderType
        vc.viewModel?.cacheData = viewModel?.cacheData
        vc.view.isHidden = true
        return vc
    }()
    
    private lazy var vcStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 0
        stackView.addArrangedSubview(startingVC.view)
        stackView.addArrangedSubview(fieldVC.view)
        return stackView
    }()
    
    //    private lazy var defaultButton: UIButton = {
    //        return createOperationButton(title: "両方")
    //    }()
    
    private lazy var startingOnyButton: UIButton = {
        return createOperationButton(title: "スタメン表")
    }()
    
    private lazy var fieldOnlyButton: UIButton = {
        return createOperationButton(title: "フィールド")
    }()
    
    private func createOperationButton(title: String) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title , for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.backgroundColor = .operationButtonColor
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
        //stackView.addArrangedSubview(defaultButton)
        stackView.addArrangedSubview(startingOnyButton)
        stackView.addArrangedSubview(fieldOnlyButton)
        return stackView
    }()
    
    //    @objc private func onClickDefault(_ sender: UIButton) {
    //        startingVC.view.isHidden = false
    //        fieldVC.view.isHidden = false
    //    }
    
    @objc private func onClickStarting(_ sender: UIButton) {
        startingVC.view.isHidden = false
        fieldVC.view.isHidden = true
    }
    
    @objc private func onClickField(_ sender: UIButton) {
        startingVC.view.isHidden = true
        fieldVC.view.isHidden = false
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        startingVC.reloadTable()
        fieldVC.prepareForAppear()
    }
    
    private func setupView() {
        view.backgroundColor = .appBackGroundColor
        view.addSubview(vcStack)
        view.addSubview(operationButtonsStack)
        view.addSubview(bannerAD)
        //        defaultButton.addTarget(self, action: #selector(onClickDefault), for: .touchUpInside)
        startingOnyButton.addTarget(self, action: #selector(onClickStarting), for: .touchUpInside)
        fieldOnlyButton.addTarget(self, action: #selector(onClickField), for: .touchUpInside)
        
        let screenWidth = view.frame.size.width
        let spaceAd = -3.0
        
        NSLayoutConstraint.activate([
            operationButtonsStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            operationButtonsStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            operationButtonsStack.heightAnchor.constraint(equalToConstant: 40),
            operationButtonsStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            vcStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            vcStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            vcStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            vcStack.heightAnchor.constraint(equalToConstant: screenWidth),
            bannerAD.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bannerAD.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: spaceAd),
        ])
    }
}
