//
//  OrderTableCell.swift
//  BaseballLineupIOS
//
//  Created by Koro Saka on 2020-11-17.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import UIKit
class OrderTableCell: UITableViewCell {
    var orderVM: OrderViewModel?
    var parentViewModel: CustomTabBarViewModel?
    var orderNum: OrderNum?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var defaultTextSize: Double = {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 48.0
        }
        return 24.0
    }()
    
    lazy var numButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: defaultTextSize)
        button.backgroundColor = .systemBlue
        return button
    }()
    
    lazy var positionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: defaultTextSize)
        label.textColor = .labelTextColor
        label.textAlignment = .center
        return label
    }()
    
    lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: defaultTextSize)
        label.textColor = .labelTextColor
        label.textAlignment = .center
        return label
    }()
    
    private func setupView() {
        var buttonWidth = 80.0
        var buttonHeight = 45.0
        var spaceBetweenButtonPosition = 10.0
        var positionWidth = 70.0
        if UIDevice.current.userInterfaceIdiom == .pad {
            buttonWidth = 160.0
            buttonHeight = 90.0
            spaceBetweenButtonPosition = 50.0
            positionWidth = 140.0
        }
        
        contentView.backgroundColor = .white
        contentView.addSubview(numButton)
        contentView.addSubview(positionLabel)
        contentView.addSubview(nameLabel)
        numButton.addTarget(self, action: #selector(onClickNum), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            numButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 2),
            numButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            numButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            numButton.widthAnchor.constraint(equalToConstant: buttonWidth),
            numButton.heightAnchor.constraint(equalToConstant: buttonHeight),
            
            positionLabel.leadingAnchor.constraint(equalTo: numButton.trailingAnchor, constant: spaceBetweenButtonPosition),
            positionLabel.widthAnchor.constraint(equalToConstant: positionWidth),
            positionLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            nameLabel.leadingAnchor.constraint(equalTo: positionLabel.trailingAnchor, constant: 5),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    @objc func onClickNum(_ sender: UIButton) {
        guard let _orderVM = orderVM else { return }
        guard let _parentVM = parentViewModel else { return }
        guard let _orderNum = orderNum else { return }
        
        if _parentVM.isExchangingStartingSub {
            _parentVM.selectStartingPlayer(orderNum: _orderNum)
        } else {
            _orderVM.selectPlayer(selectedNum: _orderNum)
            // MARK: while reloading table, numButton's color will be changed (the reason why button color isn't changed here is because when more than 2 buttons are selected, every selected buttons' color will be changed)
            _orderVM.delegate?.reloadOrder()
        }
        
        
    }
}
