//
//  SettingViewController.swift
//  BaseballLineupIOS
//
//  Created by Koro Saka on 2021-03-06.
//  Copyright © 2021 Koro Saka. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
    
    @IBOutlet weak var policyLink: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        registerPolicyLink()
    }
    
    private func registerPolicyLink() {
        //MARK: ref: https://qiita.com/shtnkgm/items/3c8b6b794219fbf087ba
        let baseString = Constants.PRIVACY_POLICY
        let policyURL = Constants.PRIVACY_POLICY_URL
        let attributedString = NSMutableAttributedString(string: baseString)
        attributedString.addAttribute(.link,
                                      value: policyURL,
                                      range: NSString(string: baseString).range(of: baseString))
        policyLink.attributedText = attributedString
        policyLink.isSelectable = true
        policyLink.isEditable = false
        policyLink.delegate = self
    }
    
    
    @IBAction func onClickClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension SettingViewController: UITextViewDelegate {
    func textView(_ textView: UITextView,
                  shouldInteractWith URL: URL,
                  in characterRange: NSRange,
                  interaction: UITextItemInteraction) -> Bool {
        
        UIApplication.shared.open(URL)
        
        return false
    }
}
