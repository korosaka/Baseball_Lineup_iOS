//
//  SubMemberViewController.swift
//  BaseballLineupIOS
//
//  Created by Koro Saka on 2020-12-07.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import UIKit

class SubMemberViewController: UIViewController {
    
    var viewModel: SubMemberViewModel?
    var parentViewModel: CustomTabBarViewModel?
    
    @IBOutlet weak var subPlayerTable: UITableView!
    
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
        subPlayerTable.dataSource = self
    }
}

extension SubMemberViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let subTableCell = tableView.dequeueReusableCell(withIdentifier: "SubPlayerTableCell", for: indexPath) as? SubPlayerTableCell else {
            fatalError("Could not create ReviewCell")
        }
        
        
        subTableCell.subButton.backgroundColor = .systemBlue
        subTableCell.subButton.layer.cornerRadius = 15
        subTableCell.subButton.layer.borderColor = UIColor.black.cgColor
        subTableCell.subButton.layer.borderWidth = 2
        
        designRoleLabel(uiLabel: subTableCell.pitcherLabel)
        designRoleLabel(uiLabel: subTableCell.hitterLabel)
        designRoleLabel(uiLabel: subTableCell.runnerLabel)
        designRoleLabel(uiLabel: subTableCell.fielderLabel)
        
        subTableCell.nameText.text = "テスト太郎"
        return subTableCell
    }
    
    func designRoleLabel(uiLabel: UILabel) {
        uiLabel.layer.cornerRadius = 5
        uiLabel.clipsToBounds = true
        uiLabel.layer.borderColor = UIColor.black.cgColor
        uiLabel.layer.borderWidth = 0.7
    }
}
