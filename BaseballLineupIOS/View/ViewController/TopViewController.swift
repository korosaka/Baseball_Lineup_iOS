//
//  ViewController.swift
//  BaseballLineupIOS
//
//  Created by Koro Saka on 2020-11-02.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import UIKit

class TopViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func onClickNoDH(_ sender: Any) {
        performSegue(withIdentifier: "goOrderScreen", sender: nil)
    }
    
    @IBAction func onClickDH(_ sender: Any) {
        performSegue(withIdentifier: "goOrderScreen", sender: nil)
    }
}

