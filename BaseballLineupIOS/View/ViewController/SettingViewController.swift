//
//  SettingViewController.swift
//  BaseballLineupIOS
//
//  Created by Koro Saka on 2021-03-06.
//  Copyright © 2021 Koro Saka. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {
    
    private let modal: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray
        return view
    }()
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("閉じる" , for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    private let policyLink: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.boldSystemFont(ofSize: 20)
        textView.textAlignment = .center
        textView.backgroundColor = .clear
        return textView
    }()
    
    private let storeReviewLink: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = UIFont.boldSystemFont(ofSize: 20)
        textView.textAlignment = .center
        textView.backgroundColor = .clear
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        registerPolicyLink()
        registerStoreReviewLink()
    }
    
    private func setupView() {
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        view.addSubview(modal)
        view.addSubview(closeButton)
        view.addSubview(policyLink)
        view.addSubview(storeReviewLink)
        closeButton.addTarget(self, action: #selector(onClickClose), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            modal.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            modal.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            modal.heightAnchor.constraint(equalToConstant: view.frame.size.height * 0.4),
            modal.widthAnchor.constraint(equalToConstant: view.frame.size.width * 0.7),
            closeButton.topAnchor.constraint(equalTo: modal.topAnchor, constant: 3),
            closeButton.leadingAnchor.constraint(equalTo: modal.leadingAnchor, constant: 3),
            policyLink.centerYAnchor.constraint(equalTo: modal.centerYAnchor, constant: -25),
            policyLink.heightAnchor.constraint(equalToConstant: 50),
            policyLink.leadingAnchor.constraint(equalTo: modal.leadingAnchor),
            policyLink.trailingAnchor.constraint(equalTo: modal.trailingAnchor),
            storeReviewLink.leadingAnchor.constraint(equalTo: modal.leadingAnchor),
            storeReviewLink.trailingAnchor.constraint(equalTo: modal.trailingAnchor),
            storeReviewLink.topAnchor.constraint(equalTo: policyLink.bottomAnchor, constant: 10),
            storeReviewLink.heightAnchor.constraint(equalToConstant: 50),
        ])
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
    
    private func registerStoreReviewLink() {
        let baseString = Constants.STORE_REVIEW
        let storeURL = Constants.STORE_REVIEW_URL
        let attributedString = NSMutableAttributedString(string: baseString)
        attributedString.addAttribute(.link,
                                      value: storeURL,
                                      range: NSString(string: baseString).range(of: baseString))
        storeReviewLink.attributedText = attributedString
        storeReviewLink.isSelectable = true
        storeReviewLink.isEditable = false
        storeReviewLink.delegate = self
    }
    
    @objc func onClickClose(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func backToPrevious() {
        navigationController?.popViewController(animated: true)
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
