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
    
    let numButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        button.backgroundColor = .systemBlue
        button.addTarget(self, action: #selector(onClickNum), for: .touchUpInside)
        return button
    }()
    
    let positionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .tintColor
        label.textAlignment = .center
        return label
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 26)
        label.textColor = .tintColor
        label.textAlignment = .center
        return label
    }()
    
    private func setupView() {
        contentView.addSubview(numButton)
        contentView.addSubview(positionLabel)
        contentView.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            numButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 2),
            numButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2),
            numButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2),
            numButton.widthAnchor.constraint(equalToConstant: 90),
            numButton.heightAnchor.constraint(equalToConstant: 50),
            
            positionLabel.leadingAnchor.constraint(equalTo: numButton.trailingAnchor, constant: 10),
            positionLabel.widthAnchor.constraint(equalToConstant: 70),
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
