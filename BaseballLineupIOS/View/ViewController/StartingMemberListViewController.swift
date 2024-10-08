//
//  StartingMemberListViewController.swift
//  BaseballLineupIOS
//
//  Created by 坂公郎 on 2024/07/23.
//  Copyright © 2024 Koro Saka. All rights reserved.
//

import UIKit
import GoogleMobileAds

class StartingMemberListViewController: UIViewController {
    
    var viewModel: StartingMemberListViewModel?
    let cellIdentifier = "starting_member_cell"
    private var isOnSquare: Bool?
    
    private lazy var orderTable: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(StartingMemberListCell.self, forCellReuseIdentifier: cellIdentifier)
        table.layer.cornerRadius = 8
        table.backgroundColor = .white
        return table
    }()
    
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
        orderTable.dataSource = self
        orderTable.delegate = self
        orderTable.tableFooterView = UIView()
        orderTable.tableHeaderView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reloadTable()
    }
    
    func reloadTable() {
        orderTable.reloadData()
    }
    
    private func setupView() {
        view.backgroundColor = .appBackGroundColor
        view.addSubview(orderTable)
        
        NSLayoutConstraint.activate([
            orderTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            orderTable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            orderTable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            orderTable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
        ])
    }
    
}

extension StartingMemberListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let tableSize = viewModel?.getOrdeSize() else {
            return 0
        }
        return tableSize
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let startingListTableCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? StartingMemberListCell else {
            fatalError("Could not create ReviewCell")
        }
        startingListTableCell.selectionStyle = .none
        guard let vm = viewModel else { return startingListTableCell }
        let orderNum = OrderNum(order: indexPath.row + 1)
        let startingPlayer = vm.getStatingPlayer(num: orderNum)
        startingListTableCell.numLabel.text = vm.getNumText(orderNum: orderNum)
        startingListTableCell.positionLabel.text = "(\(startingPlayer.position.description))"
        
        let name = startingPlayer.name.forDisplay
        let defaultTextSize = startingListTableCell.defaultTextSize
        let defaultTextCount = 6
        var textSize = defaultTextSize
        if name.count > defaultTextCount {
            textSize = Double(Int(defaultTextSize) * defaultTextCount / name.count)
        }
        
        if isOnSquare == true {
            let defaultPlayerCount = Constants.PLAYERS_NUMBER_NORMAL
            let orderSize = vm.getOrdeSize()
            let adjustedTextSize = Double(Int(defaultTextSize) * defaultPlayerCount / orderSize)
            startingListTableCell.numLabel.font = UIFont.boldSystemFont(ofSize: CGFloat(adjustedTextSize))
            startingListTableCell.positionLabel.font = UIFont.boldSystemFont(ofSize: CGFloat(adjustedTextSize))
            if adjustedTextSize < textSize {
                textSize = adjustedTextSize
            }
        }
        
        startingListTableCell.nameLabel.font = UIFont.boldSystemFont(ofSize: CGFloat(textSize))
        startingListTableCell.nameLabel.text = name
        
        return startingListTableCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let vm = viewModel else { return 0 }
        let playerCount = vm.getOrdeSize()
        if playerCount > 0 {
            let height = Float(tableView.frame.size.height) / Float(playerCount)
            //MARK: returing Decimal number(ex: 65.4 (65.0 is safe)) causes the bug that there are unexpected separator lines in Table
            return CGFloat(floor(height))
        } else {
            return 0
        }
    }
    
}
