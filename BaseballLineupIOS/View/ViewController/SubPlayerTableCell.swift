//
//  SubPlayerTableCell.swift
//  BaseballLineupIOS
//
//  Created by Koro Saka on 2020-12-07.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import UIKit
class SubPlayerTableCell: UITableViewCell {
    var viewModel: SubMemberViewModel?
    var parentViewModel: CustomTabBarViewModel?
    var tableIndex: Int?
    
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
    
    lazy var subButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: defaultTextSize)
        button.backgroundColor = .systemBlue
        button.setTitle("控", for: .normal)
        return button
    }()
    
    lazy var pitcherLabel: UILabel = {
        return createRoleLabel(text: "投手", color: .systemRed)
    }()
    
    lazy var hitterLabel: UILabel = {
        return createRoleLabel(text: "代打", color: .systemGreen)
    }()
    
    lazy var fielderLabel: UILabel = {
        return createRoleLabel(text: "守備", color: .systemBlue)
    }()
    
    lazy var runnerLabel: UILabel = {
        return createRoleLabel(text: "代走", color: .systemYellow)
    }()
    
    private func createRoleLabel(text: String, color: UIColor) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        var textSize = 16.0
        if UIDevice.current.userInterfaceIdiom == .pad {
            textSize = 32.0
        }
        label.font = UIFont.boldSystemFont(ofSize: textSize)
        label.textAlignment = .center
        label.text = text
        return label
    }
    
    private lazy var pitcherAndRuunerStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 1
        stackView.addArrangedSubview(pitcherLabel)
        stackView.addArrangedSubview(runnerLabel)
        return stackView
    }()
    
    private lazy var hitterAndfielderStack: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 1
        stackView.addArrangedSubview(hitterLabel)
        stackView.addArrangedSubview(fielderLabel)
        return stackView
    }()
    
    private lazy var roleLabels: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .fill
        stackView.spacing = 1
        stackView.addArrangedSubview(pitcherAndRuunerStack)
        stackView.addArrangedSubview(hitterAndfielderStack)
        return stackView
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
        contentView.addSubview(subButton)
        contentView.addSubview(roleLabels)
        contentView.addSubview(nameLabel)
        subButton.addTarget(self, action: #selector(onClickSub), for: .touchUpInside)
        
        var subButtonWidth = 60.0
        var subButtonHeight = 45.0
        var roleLabelsWidth = 90.0
        var roleLabelsHeight = 50.0
        if UIDevice.current.userInterfaceIdiom == .pad {
            subButtonWidth = 120.0
            subButtonHeight = 90.0
            roleLabelsWidth = 180.0
            roleLabelsHeight = 100.0
        }
        
        NSLayoutConstraint.activate([
            subButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 2),
            subButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            subButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            subButton.widthAnchor.constraint(equalToConstant: subButtonWidth),
            subButton.heightAnchor.constraint(equalToConstant: subButtonHeight),
            
            roleLabels.leadingAnchor.constraint(equalTo: subButton.trailingAnchor, constant: 5),
            roleLabels.widthAnchor.constraint(equalToConstant: roleLabelsWidth),
            roleLabels.heightAnchor.constraint(equalToConstant: roleLabelsHeight),
            roleLabels.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            nameLabel.leadingAnchor.constraint(equalTo: roleLabels.trailingAnchor, constant: 5),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
    }
    
    @objc func onClickSub(_ sender: Any) {
        
        guard let _index = tableIndex else { return }
        guard let _parentVM = parentViewModel else { return }
        guard let _VM = viewModel else { return }
        
        if _parentVM.isExchangingStartingSub {
            _parentVM.selectSubPlayer(index: _index)
            _VM.delegate?.reloadOrder()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                _parentVM.switchScreen(screenIndex: 0)
            }
            
        } else {
            _VM.selectPlayer(index: _index)
            _VM.delegate?.reloadOrder()
        }
        
    }
    
    
}
