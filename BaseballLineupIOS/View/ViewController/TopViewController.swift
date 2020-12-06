//
//  ViewController.swift
//  BaseballLineupIOS
//
//  Created by Koro Saka on 2020-11-02.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import UIKit

class TopViewController: UIViewController {
    
    var viewModel: TopViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewModel = .init()
    }
    
    @IBAction func onClickNoDH(_ sender: Any) {
        performSegue(withIdentifier: "goOrderScreen", sender: OrderType.Normal)
    }
    
    @IBAction func onClickDH(_ sender: Any) {
        performSegue(withIdentifier: "goOrderScreen", sender: OrderType.DH)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        viewModel?.informOrderType(segue: segue, sender: sender)
    }
}

