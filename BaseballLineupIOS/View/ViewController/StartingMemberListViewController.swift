//
//  StartingMemberListViewController.swift
//  BaseballLineupIOS
//
//  Created by 坂公郎 on 2024/07/23.
//  Copyright © 2024 Koro Saka. All rights reserved.
//

import UIKit
import GoogleMobileAds

class StartingMemberListViewController: BaseADViewController {
    
    var viewModel: StartingMemberListViewModel?
    let cellIdentifier = "starting_member_cell"
    
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
    
    convenience init() {
        self.init(nibName: nil, bundle: nil)
    }
    
    func setup() {
        viewModel = .init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        orderTable.dataSource = self
    }
    
    private func setupView() {
        view.backgroundColor = .appBackGroundColor
        view.addSubview(orderTable)
        view.addSubview(bannerAD)
        
        NSLayoutConstraint.activate([
            orderTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 3),
            orderTable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 5),
            orderTable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -5),
            orderTable.bottomAnchor.constraint(equalTo: bannerAD.topAnchor, constant: -3),
            bannerAD.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bannerAD.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -3),
        ])
    }
    
}

extension StartingMemberListViewController: UITableViewDataSource {
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
        let orderNum = OrderNum(order: indexPath.row + 1)
        guard let startingPlayer = viewModel?.getStatingPlayer(num: orderNum) else { return startingListTableCell }
        startingListTableCell.numLabel.text = viewModel!.getNumText(orderNum: orderNum)
        startingListTableCell.positionLabel.text = startingPlayer.position.description
        
        let name = startingPlayer.name.forDisplay
        if name.count < 8 {
            startingListTableCell.nameLabel.font = UIFont.boldSystemFont(ofSize: 24)
        } else if name.count == 8 {
            startingListTableCell.nameLabel.font = UIFont.boldSystemFont(ofSize: 20)
        } else {
            startingListTableCell.nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        }
        startingListTableCell.nameLabel.text = name
        
        return startingListTableCell
    }
}
