//
//  OrderViewController.swift
//  BaseballLineupIOS
//
//  Created by Koro Saka on 2020-11-11.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import UIKit

class OrderViewController: UIViewController {
    
    var viewModel: OrderViewModel?
    @IBOutlet weak var orderTable: UITableView!
    
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
    
    @IBOutlet weak var testLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        testLabel.text = viewModel?.orderType
        orderTable.dataSource = self
        orderTable.delegate = self
        // Do any additional setup after loading the view.
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
        
        orderTableCell.numButton.setTitle("4番", for: .normal)
        orderTableCell.positionLabel.text = "(三)"
        orderTableCell.nameLabel.text = "長嶋"
        
        return orderTableCell
    }
}

extension OrderViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //
    }
}
