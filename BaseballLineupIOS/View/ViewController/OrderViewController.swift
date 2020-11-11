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
        // Do any additional setup after loading the view.
    }
    
}
