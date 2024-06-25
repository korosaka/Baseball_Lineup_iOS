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
    
    func informOrderType(segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goOrderScreen" {
            let tabBarController = segue.destination as! CustomTabBarController
            tabBarController.viewModel?.orderType = sender as? OrderType
        }
    }
    
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
            let result = try await product.purchase()
            switch result {
            case let .success(.verified(transaction)):
                await transaction.finish()
                UsingUserDefaults.purchasedSpecial()
                title = Constants.TITLE_COMPLETE
                message = Constants.SUCCESS_PURCHASE
            case .success(.unverified(_, _)):
                //TODO: check before release
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
        } catch _ {
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
            return .systemYellow
        } else {
            return .gray
        }
    }
    
}

enum CustomError: Error {
    case noProductError
}
