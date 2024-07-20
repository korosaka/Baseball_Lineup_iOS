//
//  ViewController.swift
//  BaseballLineupIOS
//
//  Created by Koro Saka on 2020-11-02.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import UIKit
import AppTrackingTransparency
import AdSupport
import GoogleMobileAds
import StoreKit

class TopViewController: UIViewController {
    
    var viewModel: TopViewModel?
    private var isDoneTrackingCheck = false
    private var isShownInterstitial = false
    private var interstitial: GADInterstitialAd?
    private var indicator: UIActivityIndicatorView?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.text = Constants.TITLE_TOP
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 36)
        label.backgroundColor = .systemGreen
        label.textColor = .white
        return label
    }()
    
    private lazy var nonDHOrderButton: UIButton = {
        return createOrderButton(.Normal)
    }()
    
    private lazy var dhOrderButton: UIButton = {
        return createOrderButton(.DH)
    }()
    
    private lazy var specialOrderButton: UIButton = {
        return createOrderButton(.Special)
    }()
    
    private func createOrderButton(_ type: OrderButtonType) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(type.buttonTitle , for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 24)
        button.addTarget(self, action: #selector(onClickOrderButton), for: .touchUpInside)
        button.tag = type.buttonTag
        button.backgroundColor = type.buttonColor
        button.setTitleColor(.white, for: .normal)
        return button
    }
    
    private lazy var restoreButton: UIButton = {
        let button = createStoreButton(title: Constants.RESTORE_PURCHASE, color: .systemIndigo)
        button.addTarget(self, action: #selector(onClickRestore), for: .touchUpInside)
        return button
    }()
    
    private lazy var purchaseButton: UIButton = {
        let button = createStoreButton(title: Constants.WHAT_IS_ALL_HITTER, color: .systemPurple)
        button.addTarget(self, action: #selector(onClickPurchase), for: .touchUpInside)
        return button
    }()
    
    private func createStoreButton(title: String, color: UIColor) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title , for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.backgroundColor = color
        button.setTitleColor(.white, for: .normal)
        return button
    }
    
    private lazy var orderButtons: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .center
        
        stackView.addArrangedSubview(UIView())
        stackView.addArrangedSubview(nonDHOrderButton)
        stackView.addArrangedSubview(dhOrderButton)
        stackView.addArrangedSubview(specialOrderButton)
        stackView.addArrangedSubview(UIView())
        
        return stackView
    }()
    
    private lazy var buttonsAboutStore: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 30
        stackView.alignment = .center
        stackView.addArrangedSubview(restoreButton)
        stackView.addArrangedSubview(purchaseButton)
        
        return stackView
    }()
    
    private func createDescription(_ text: String) -> UILabel {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 0
        return label
    }
    
    private lazy var descriptions: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 0
        stackView.alignment = .leading
        
        stackView.addArrangedSubview(createDescription(Constants.DESCRIPTION_1))
        stackView.addArrangedSubview(createDescription(Constants.DESCRIPTION_2))
        stackView.addArrangedSubview(createDescription(Constants.DESCRIPTION_3))
        
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        viewModel = .init()
        setupView()
        createIndicator()
        checkPurchasingState()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(titleLabel)
        view.addSubview(orderButtons)
        view.addSubview(buttonsAboutStore)
        view.addSubview(descriptions)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            
            orderButtons.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0),
            orderButtons.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            orderButtons.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50),
            orderButtons.bottomAnchor.constraint(equalTo: buttonsAboutStore.topAnchor, constant: 0),
            nonDHOrderButton.heightAnchor.constraint(equalToConstant: 50),
            nonDHOrderButton.leadingAnchor.constraint(equalTo: orderButtons.leadingAnchor, constant: 0),
            nonDHOrderButton.trailingAnchor.constraint(equalTo: orderButtons.trailingAnchor, constant: 0),
            dhOrderButton.heightAnchor.constraint(equalToConstant: 50),
            dhOrderButton.leadingAnchor.constraint(equalTo: orderButtons.leadingAnchor, constant: 0),
            dhOrderButton.trailingAnchor.constraint(equalTo: orderButtons.trailingAnchor, constant: 0),
            specialOrderButton.heightAnchor.constraint(equalToConstant: 50),
            specialOrderButton.leadingAnchor.constraint(equalTo: orderButtons.leadingAnchor, constant: 0),
            specialOrderButton.trailingAnchor.constraint(equalTo: orderButtons.trailingAnchor, constant: 0),
            
            buttonsAboutStore.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            buttonsAboutStore.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50),
            buttonsAboutStore.bottomAnchor.constraint(equalTo: descriptions.topAnchor, constant: -10),
            buttonsAboutStore.heightAnchor.constraint(equalToConstant: 40),
            restoreButton.topAnchor.constraint(equalTo: buttonsAboutStore.topAnchor, constant: 0),
            restoreButton.bottomAnchor.constraint(equalTo: buttonsAboutStore.bottomAnchor, constant: 0),
            purchaseButton.topAnchor.constraint(equalTo: buttonsAboutStore.topAnchor, constant: 0),
            purchaseButton.bottomAnchor.constraint(equalTo: buttonsAboutStore.bottomAnchor, constant: 0),
            
            descriptions.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            descriptions.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -50),
            descriptions.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
        ])
    }
    
    private func createIndicator() {
        indicator = UIActivityIndicatorView()
        if let _indicator = indicator {
            _indicator.center = view.center
            _indicator.style = .large
            _indicator.color = .green
            view.addSubview(_indicator)
        }
    }
    
    private var isIndicatorAnimating: Bool {
        get {
            guard let _indicator = indicator else { return false }
            return _indicator.isAnimating
        }
    }
    
    private func checkPurchasingState() {
        guard let vm = viewModel else { return }
        let purchased = UsingUserDefaults.isSpecialPurchased
        specialOrderButton.setTitle(vm.getSpecialOrderButttonText(purchased: purchased), for: .normal)
        specialOrderButton.isEnabled = purchased
        purchaseButton.isHidden = purchased
        restoreButton.isHidden = purchased
        descriptions.isHidden = purchased
        specialOrderButton.setTitleColor(vm.getSpecialOrderButttonTextColor(purchased: purchased), for: .normal)
        specialOrderButton.backgroundColor = vm.getSpecialOrderButttonColor(purchased: purchased)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !isDoneTrackingCheck { requestIDFA() } // showing Interstitial is only once!
    }
    
    @objc private func onClickRestore(_ sender: UIButton) {
        guard !isIndicatorAnimating, let vm = viewModel else { return }
        indicator?.startAnimating()
        Task {
            await vm.restore { title, message in
                let completionDialog = self.createSimpleAlert(title, message)
                self.addOKToAlert(completionDialog)
                Task {@MainActor in
                    self.indicator?.stopAnimating()
                    self.checkPurchasingState()
                    self.present(completionDialog, animated: true, completion:nil)
                }
            }
        }
    }
    
    @objc private func onClickPurchase(_ sender: UIButton) {
        guard !isIndicatorAnimating, let vm = viewModel else { return }
        
        indicator?.startAnimating()
        Task {
            var alertDialog: UIAlertController? = nil
            
            await vm.fetchAllHitterProduct { result in
                switch result {
                case .success(let product):
                    
                    let allHitterDescription =
                    product.description
                    + Constants.ALL_HITTER_DESC_1
                    + product.displayPrice
                    + Constants.ALL_HITTER_DESC_2
                    + "\n\n"
                    + Constants.PRIVACY_POLICY
                    + "\n\n"
                    + Constants.TERMS_OF_USE
                    
                    Task {@MainActor in
                        //To make the link interactive, UITextView is used within UIAlertController
                        let textView = UITextView()
                        textView.isEditable = false
                        textView.isScrollEnabled = false
                        textView.dataDetectorTypes = .link
                        
                        let attributedString = NSMutableAttributedString(string: allHitterDescription)
                        
                        attributedString.addAttribute(.link,
                                                      value: URL(string: Constants.PRIVACY_POLICY_URL)!,
                                                      range: NSString(string: allHitterDescription).range(of: Constants.PRIVACY_POLICY))
                        
                        attributedString.addAttribute(.link,
                                                      value: URL(string: Constants.TERMS_OF_USE_URL)!,
                                                      range: NSString(string: allHitterDescription).range(of: Constants.TERMS_OF_USE))
                        
                        textView.attributedText = attributedString
                        
                        alertDialog = self.createSimpleAlert(product.displayName, Constants.EMPTY)
                        guard let  _dialog = alertDialog else { return }
                        
                        //TODO: this is the temporary dealing (should be dealt depending on Light/Dark mode)
                        _dialog.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor.darkGray
                        
                        _dialog.addAction(UIAlertAction(title: Constants.GO_TO_PURCHASE, style:UIAlertAction.Style.default){
                            (action:UIAlertAction)in
                            self.startPurchaseFlow(product: product)
                        })
                        _dialog.addAction(UIAlertAction(title: Constants.TITLE_CANCEL, style:UIAlertAction.Style.cancel, handler: nil))
                        _dialog.view.addSubview(textView)
                        textView.translatesAutoresizingMaskIntoConstraints = false
                        textView.centerXAnchor.constraint(equalTo: _dialog.view.centerXAnchor).isActive = true
                        textView.heightAnchor.constraint(equalToConstant: 240).isActive = true
                        textView.widthAnchor.constraint(equalToConstant: 220).isActive = true
                        textView.topAnchor.constraint(equalTo: _dialog.view.topAnchor, constant: 50).isActive = true
                        textView.bottomAnchor.constraint(equalTo: _dialog.view.bottomAnchor, constant: -50).isActive = true
                        textView.backgroundColor = .clear
                    }
                    
                case .failure(_):
                    alertDialog = self.createSimpleAlert(Constants.TITLE_ERROR, Constants.FAIL_FETCH_PRODUCT)
                    self.addOKToAlert(alertDialog)
                }
            }
            
            Task {@MainActor in
                self.indicator?.stopAnimating()
                guard let _dialog = alertDialog else { return }
                self.present(_dialog, animated: true, completion:nil)
            }
        }
    }
    
    private func createSimpleAlert(_ title: String, _ message: String) -> UIAlertController {
        UIAlertController(title: title,
                          message: message,
                          preferredStyle: UIAlertController.Style.alert)
    }
    
    private func addOKToAlert(_ alert: UIAlertController?) {
        alert?.addAction(UIAlertAction(title: Constants.OK, style: .default, handler: nil))
    }
    
    private func startPurchaseFlow(product: Product) {
        guard !isIndicatorAnimating, let vm = viewModel else { return }
        indicator?.startAnimating()
        Task {
            await vm.purchaseProduct(product) { title, message in
                let completionDialog = self.createSimpleAlert(title, message)
                self.addOKToAlert(completionDialog)
                Task {@MainActor in
                    self.indicator?.stopAnimating()
                    self.present(completionDialog, animated: true, completion:nil)
                    self.checkPurchasingState()
                }
            }
        }
    }
    
    @objc private func onClickOrderButton(_ sender:UIButton) {
        switch sender.tag {
        case OrderButtonType.Normal.buttonTag:
            onClickOrderType(type: .Normal)
        case OrderButtonType.DH.buttonTag:
            onClickOrderType(type: .DH)
        case OrderButtonType.Special.buttonTag:
            onClickOrderType(type: .Special)
        default:
            return
        }
    }
    
    private func onClickOrderType(type: OrderType) {
        if isDoneTrackingCheck, !isIndicatorAnimating {
            showInterstitial()
            let customTabBarController = CustomTabBarController()
            customTabBarController.setupViewControllers(type)
            self.navigationController?.pushViewController(customTabBarController, animated: true)
        }
    }
    
    /*
     ref: https://developers.google.com/admob/ios/ios14#request
     */
    func requestIDFA() {
        indicator?.startAnimating()
        Thread.sleep(forTimeInterval: 0.5) //to fix the bug of not showing tracking request: https://qiita.com/renave/items/b408aad151df722be747
        if #available(iOS 14, *) {
            ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
                self.loadInterstitialAd()
            })
        } else {
            loadInterstitialAd()
        }
    }
    
    private func loadInterstitialAd() {
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID: Constants.INTERSTITIAL_ID,
                               request: request,
                               completionHandler: { [self] ad, error in
            self.isDoneTrackingCheck = true
            indicator?.stopAnimating()
            if let error = error {
                print("Failed to load interstitial ad with error: \(error.localizedDescription)")
                return
            }
            interstitial = ad
        }
        )
    }
    
    private func showInterstitial() {
        if isShownInterstitial { return }
        if let _interstitial = interstitial {
            _interstitial.present(fromRootViewController: self)
            isShownInterstitial = true
        } else {
            print("Ad wasn't ready")
        }
    }
    
    private enum OrderButtonType {
        case Normal, DH, Special
        
        var buttonTag: Int {
            switch self {
            case .Normal:
                return 0
            case .DH:
                return 1
            case .Special:
                return 2
            }
        }
        
        var buttonTitle: String {
            switch self {
            case .Normal:
                return Constants.NON_DH
            case .DH:
                return Constants.USE_DH
            case .Special:
                return Constants.ALL_HITTER_AVAILABLE
            }
        }
        
        var buttonColor: UIColor {
            switch self {
            case .Normal:
                return .blue
            case .DH:
                return .red
            case .Special:
                return .systemYellow
            }
        }
    }
}

