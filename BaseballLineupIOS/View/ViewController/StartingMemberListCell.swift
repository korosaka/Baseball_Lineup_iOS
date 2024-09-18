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
    
    lazy var defaultTextSize: Double = {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 56.0
        }
        return 28.0
    }()
    
    lazy var numLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: defaultTextSize)
        label.textColor = .labelTextColor
        label.textAlignment = .center
        return label
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
        contentView.backgroundColor = .white
        contentView.addSubview(numLabel)
        contentView.addSubview(positionLabel)
        contentView.addSubview(nameLabel)
        
        var numPositionLabelWidth = 80.0
        if UIDevice.current.userInterfaceIdiom == .pad {
            numPositionLabelWidth = 160.0
        }
        
        NSLayoutConstraint.activate([
            numLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 2),
            numLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            numLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            numLabel.widthAnchor.constraint(equalToConstant: numPositionLabelWidth),
            
            positionLabel.leadingAnchor.constraint(equalTo: numLabel.trailingAnchor, constant: 0),
            positionLabel.widthAnchor.constraint(equalToConstant: numPositionLabelWidth),
            positionLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            nameLabel.leadingAnchor.constraint(equalTo: positionLabel.trailingAnchor, constant: 0),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

}
