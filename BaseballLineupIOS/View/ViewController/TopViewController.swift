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
    private var interstitial: GADInterstitialAd?
    private var indicator: UIActivityIndicatorView?
    
    private let titleLabel: UILabel = {
        let label = DecorateLabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.strokeColor = UIColor.appTitleColor
        label.textColor = UIColor.white
        label.strokeSize = 4.0
        label.text = Constants.TITLE_TOP
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 40)
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
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 28)
        button.tag = type.buttonTag
        button.backgroundColor = type.buttonColor
        button.setTitleColor(.white, for: .normal)
        button.addLargeButtonDesign()
        return button
    }
    
    private lazy var restoreButton: UIButton = {
        return createStoreButton(title: Constants.RESTORE_PURCHASE, color: .systemIndigo)
    }()
    
    private lazy var purchaseButton: UIButton = {
        return createStoreButton(title: Constants.WHAT_IS_ALL_HITTER, color: .systemIndigo)
    }()
    
    private func createStoreButton(title: String, color: UIColor) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title , for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.backgroundColor = color
        button.setTitleColor(.white, for: .normal)
        button.addOperationButtonDesign()
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
        label.textColor = .gray
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
        view.backgroundColor = .appBackGroundColor
        view.addSubview(titleLabel)
        view.addSubview(orderButtons)
        view.addSubview(buttonsAboutStore)
        view.addSubview(descriptions)
        nonDHOrderButton.addTarget(self, action: #selector(onClickOrderButton), for: .touchUpInside)
        dhOrderButton.addTarget(self, action: #selector(onClickOrderButton), for: .touchUpInside)
        specialOrderButton.addTarget(self, action: #selector(onClickOrderButton), for: .touchUpInside)
        restoreButton.addTarget(self, action: #selector(onClickRestore), for: .touchUpInside)
        purchaseButton.addTarget(self, action: #selector(onClickPurchase), for: .touchUpInside)
        
        let defaultLeadingSpace = 50.0
        let defaultTrailingSpace = -1.0 * defaultLeadingSpace
        let orderButtonHeight = 50.0
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            orderButtons.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            orderButtons.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: defaultLeadingSpace),
            orderButtons.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: defaultTrailingSpace),
            orderButtons.bottomAnchor.constraint(equalTo: buttonsAboutStore.topAnchor),
            nonDHOrderButton.heightAnchor.constraint(equalToConstant: orderButtonHeight),
            nonDHOrderButton.leadingAnchor.constraint(equalTo: orderButtons.leadingAnchor),
            nonDHOrderButton.trailingAnchor.constraint(equalTo: orderButtons.trailingAnchor),
            dhOrderButton.heightAnchor.constraint(equalToConstant: orderButtonHeight),
            dhOrderButton.leadingAnchor.constraint(equalTo: orderButtons.leadingAnchor),
            dhOrderButton.trailingAnchor.constraint(equalTo: orderButtons.trailingAnchor),
            specialOrderButton.heightAnchor.constraint(equalToConstant: orderButtonHeight),
            specialOrderButton.leadingAnchor.constraint(equalTo: orderButtons.leadingAnchor),
            specialOrderButton.trailingAnchor.constraint(equalTo: orderButtons.trailingAnchor),
            
            buttonsAboutStore.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: defaultLeadingSpace),
            buttonsAboutStore.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: defaultTrailingSpace),
            buttonsAboutStore.bottomAnchor.constraint(equalTo: descriptions.topAnchor, constant: -10),
            buttonsAboutStore.heightAnchor.constraint(equalToConstant: 40),
            restoreButton.topAnchor.constraint(equalTo: buttonsAboutStore.topAnchor),
            restoreButton.bottomAnchor.constraint(equalTo: buttonsAboutStore.bottomAnchor),
            purchaseButton.topAnchor.constraint(equalTo: buttonsAboutStore.topAnchor),
            purchaseButton.bottomAnchor.constraint(equalTo: buttonsAboutStore.bottomAnchor),
            
            descriptions.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: defaultLeadingSpace),
            descriptions.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: defaultTrailingSpace),
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
        if purchased {
            specialOrderButton.addLargeButtonDesign()
        } else {
            specialOrderButton.layer.shadowOpacity = 0
            specialOrderButton.layer.shadowRadius = 0
            specialOrderButton.layer.shadowOffset = CGSize(width: 0, height: 0)
        }
        purchaseButton.isHidden = purchased
        restoreButton.isHidden = purchased
        descriptions.isHidden = purchased
        specialOrderButton.setTitleColor(vm.getSpecialOrderButttonTextColor(purchased: purchased), for: .normal)
        specialOrderButton.backgroundColor = vm.getSpecialOrderButttonColor(purchased: purchased)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if !isDoneTrackingCheck { requestIDFA() }
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
        guard !isIndicatorAnimating,
              let vm = viewModel,
              let policyURL = URL(string: Constants.PRIVACY_POLICY_URL),
              let tosURL = URL(string: Constants.TERMS_OF_USE_URL) else { return }
        
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
                                                      value: policyURL,
                                                      range: NSString(string: allHitterDescription).range(of: Constants.PRIVACY_POLICY))
                        
                        attributedString.addAttribute(.link,
                                                      value: tosURL,
                                                      range: NSString(string: allHitterDescription).range(of: Constants.TERMS_OF_USE))
                        
                        textView.attributedText = attributedString
                        
                        alertDialog = self.createSimpleAlert(product.displayName, Constants.EMPTY)
                        guard let  _dialog = alertDialog else { return }
                        
                        _dialog.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor.dialogColor
                        _dialog.addAction(UIAlertAction(title: Constants.GO_TO_PURCHASE, style:UIAlertAction.Style.default){
                            (action:UIAlertAction)in
                            self.startPurchaseFlow(product: product)
                        })
                        _dialog.setValue(NSAttributedString(string: product.displayName, attributes: [NSAttributedString.Key.foregroundColor : UIColor.black]), forKey: "attributedTitle")
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
        if let _interstitial = interstitial {
            _interstitial.present(fromRootViewController: self)
            loadInterstitialAd()
        } else {
            print("Ad wasn't ready")
            loadInterstitialAd()
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
                return .largeButtonColor
            case .DH:
                return .largeButtonColor
            case .Special:
                return .largeButtonColor
            }
        }
    }
}

