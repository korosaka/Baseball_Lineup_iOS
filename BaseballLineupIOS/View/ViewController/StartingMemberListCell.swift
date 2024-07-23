//
//  StartingMemberListCell.swift
//  BaseballLineupIOS
//
//  Created by 坂公郎 on 2024/07/23.
//  Copyright © 2024 Koro Saka. All rights reserved.
//

import UIKit
class StartingMemberListCell: UITableViewCell {

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let numLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .labelTextColor
        label.textAlignment = .center
        return label
    }()
    
    let positionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .labelTextColor
        label.textAlignment = .center
        return label
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textColor = .labelTextColor
        label.textAlignment = .center
        return label
    }()
    
    private func setupView() {
        contentView.backgroundColor = .white
        contentView.addSubview(numLabel)
        contentView.addSubview(positionLabel)
        contentView.addSubview(nameLabel)
        
        NSLayoutConstraint.activate([
            numLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 2),
            numLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            numLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            numLabel.widthAnchor.constraint(equalToConstant: 80),
            numLabel.heightAnchor.constraint(equalToConstant: 45),
            
            positionLabel.leadingAnchor.constraint(equalTo: numLabel.trailingAnchor, constant: 10),
            positionLabel.widthAnchor.constraint(equalToConstant: 70),
            positionLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            nameLabel.leadingAnchor.constraint(equalTo: positionLabel.trailingAnchor, constant: 5),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

}
