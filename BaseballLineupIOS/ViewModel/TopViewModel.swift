//
//  TopViewModel.swift
//  BaseballLineupIOS
//
//  Created by Koro Saka on 2020-11-11.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import UIKit
import StoreKit

class TopViewModel {
    
    func fetchAllHitterProduct(completion: @escaping (Result<Product, Error>) -> Void) async {
        let productIds = [Constants.ALL_HITTER_ID]
        guard let allHitterIndex = productIds.firstIndex(of: Constants.ALL_HITTER_ID) else { return }
        
        do {
            let products = try await Product.products(for: productIds)
            if products.isEmpty {
                throw CustomError.noProductError
            } else {
                completion(.success(products[allHitterIndex]))
            }
        } catch {
            completion(.failure(error))
        }
    }
    
    func restore(completion: @escaping (String, String) -> Void) async {
        do {
            try await AppStore.sync()
        } catch {
            completion(Constants.TITLE_ERROR, Constants.FAIL_RESTORE)
            return
        }
        
        let verificationResult = await Transaction.currentEntitlement(for: Constants.ALL_HITTER_ID)
        if case .verified = verificationResult {
            UsingUserDefaults.purchasedSpecial()
            completion(Constants.TITLE_COMPLETE, Constants.SUCCESS_RESTORE)
        } else {
            completion(Constants.TITLE_COMPLETE, Constants.EMPTY_RESTORE)
        }
    }
    
    func purchaseProduct(_ product: Product, completion: @escaping (String, String) -> Void) async {
        var title = Constants.EMPTY
        var message = Constants.EMPTY
        
        do {
            try await AppStore.sync()
            let verificationResult = await Transaction.currentEntitlement(for: Constants.ALL_HITTER_ID)
            if case .verified = verificationResult {
                //when user has already purchased before
                UsingUserDefaults.purchasedSpecial()
                title = Constants.TITLE_PURCHASED
                message = Constants.HAD_PURCHASED
            } else {
                let result = try await product.purchase()
                switch result {
                case let .success(.verified(transaction)):
                    await transaction.finish()
                    UsingUserDefaults.purchasedSpecial()
                    title = Constants.TITLE_COMPLETE
                    message = Constants.SUCCESS_PURCHASE
                case .success(.unverified(_, _)):
                    title = Constants.TITLE_ERROR
                    message = Constants.FAIL_PURCHASE
                case .pending:
                    title = Constants.TITLE_PENDING
                    message = Constants.PENDING_PURCHASE
                case .userCancelled:
                    title = Constants.TITLE_CANCEL
                    message = Constants.CANCEL_PURCHASE
                @unknown default:
                    title = Constants.TITLE_ERROR
                    message = Constants.FAIL_PURCHASE
                }
            }
        } catch {
            title = Constants.TITLE_ERROR
            message = Constants.FAIL_PURCHASE
        }
        
        completion(title, message)
    }
    
    func getSpecialOrderButttonText(purchased: Bool) -> String {
        if purchased {
            return Constants.ALL_HITTER_AVAILABLE
        } else {
            return Constants.ALL_HITTER_UNAVAILABLE
        }
    }
    
    func getSpecialOrderButttonTextColor(purchased: Bool) -> UIColor {
        if purchased {
            return .white
        } else {
            return .lightGray
        }
    }
    
    func getSpecialOrderButttonColor(purchased: Bool) -> UIColor {
        if purchased {
            return .largeButtonColor
        } else {
            return .gray
        }
    }
    
    func shouldShowInterstitial() -> Bool {
        let isTheInitialUsing = UsingUserDefaults.countOfUsingApp == 0
        if isTheInitialUsing { return false }
        
        guard let previousTime = UsingUserDefaults.savedInterstitialTime else { return true }
        let timeDifference = Date().timeIntervalSince(previousTime)
        let adIntervalTime: TimeInterval = 3600 //1hour
        return timeDifference > adIntervalTime
    }
    
}

enum CustomError: Error {
    case noProductError
}
