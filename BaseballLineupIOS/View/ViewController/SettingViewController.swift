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
    
    private lazy var policyLink: UITextView = {
        return createTextForLink()
    }()
    
    private lazy var storeReviewLink: UITextView = {
        return createTextForLink()
    }()
    
    private lazy var blogLink: UITextView = {
        return createTextForLink()
    }()
    
    private lazy var contactLink: UITextView = {
        return createTextForLink()
    }()
    
    private func createTextForLink() -> UITextView {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.textAlignment = .center
        textView.backgroundColor = .clear
        return textView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        registerPolicyLink()
        registerStoreReviewLink()
        registerBlogLink()
        registerContactLink()
    }
    
    private func setupView() {
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.7)
        view.addSubview(modal)
        view.addSubview(closeButton)
        view.addSubview(policyLink)
        view.addSubview(storeReviewLink)
        view.addSubview(blogLink)
        view.addSubview(contactLink)
        closeButton.addTarget(self, action: #selector(onClickClose), for: .touchUpInside)
        
        let defaultSpace = 10.0
        let defaultHeight = 50.0
        
        NSLayoutConstraint.activate([
            modal.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            modal.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            modal.heightAnchor.constraint(equalToConstant: view.frame.size.height * 0.6),
            modal.widthAnchor.constraint(equalToConstant: view.frame.size.width * 0.9),
            closeButton.topAnchor.constraint(equalTo: modal.topAnchor, constant: 3),
            closeButton.leadingAnchor.constraint(equalTo: modal.leadingAnchor, constant: 3),
            policyLink.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: defaultSpace),
            policyLink.heightAnchor.constraint(equalToConstant: defaultHeight),
            policyLink.leadingAnchor.constraint(equalTo: modal.leadingAnchor),
            policyLink.trailingAnchor.constraint(equalTo: modal.trailingAnchor),
            storeReviewLink.leadingAnchor.constraint(equalTo: modal.leadingAnchor),
            storeReviewLink.trailingAnchor.constraint(equalTo: modal.trailingAnchor),
            storeReviewLink.topAnchor.constraint(equalTo: policyLink.bottomAnchor, constant: defaultSpace),
            storeReviewLink.heightAnchor.constraint(equalToConstant: defaultHeight),
            blogLink.leadingAnchor.constraint(equalTo: modal.leadingAnchor),
            blogLink.trailingAnchor.constraint(equalTo: modal.trailingAnchor),
            blogLink.topAnchor.constraint(equalTo: storeReviewLink.bottomAnchor, constant: defaultSpace),
            blogLink.heightAnchor.constraint(equalToConstant: defaultHeight),
            contactLink.leadingAnchor.constraint(equalTo: modal.leadingAnchor),
            contactLink.trailingAnchor.constraint(equalTo: modal.trailingAnchor),
            contactLink.topAnchor.constraint(equalTo: blogLink.bottomAnchor, constant: defaultSpace),
            contactLink.heightAnchor.constraint(equalToConstant: defaultHeight),
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
        let baseString = Constants.STORE_REVIEW + Constants.STORE_REVIEW_MESSAGE
        let storeURL = Constants.STORE_REVIEW_URL
        let attributedString = NSMutableAttributedString(string: baseString)
        attributedString.addAttribute(.link,
                                      value: storeURL,
                                      range: NSString(string: baseString).range(of: Constants.STORE_REVIEW))
        storeReviewLink.attributedText = attributedString
        storeReviewLink.isSelectable = true
        storeReviewLink.isEditable = false
        storeReviewLink.delegate = self
    }
    
    private func registerBlogLink() {
        let baseString = Constants.BLOG + Constants.BLOG_MESSAGE
        let blogURL = Constants.BLOG_URL
        let attributedString = NSMutableAttributedString(string: baseString)
        attributedString.addAttribute(.link,
                                      value: blogURL,
                                      range: NSString(string: baseString).range(of: Constants.BLOG))
        blogLink.attributedText = attributedString
        blogLink.isSelectable = true
        blogLink.isEditable = false
        blogLink.delegate = self
    }
    
    private func registerContactLink() {
        let baseString = Constants.CONTACT_US + Constants.CONTACT_US_MESSAGE
        let contactURL = Constants.CONTACT_US_URL
        let attributedString = NSMutableAttributedString(string: baseString)
        attributedString.addAttribute(.link,
                                      value: contactURL,
                                      range: NSString(string: baseString).range(of: Constants.CONTACT_US))
        contactLink.attributedText = attributedString
        contactLink.isSelectable = true
        contactLink.isEditable = false
        contactLink.delegate = self
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
