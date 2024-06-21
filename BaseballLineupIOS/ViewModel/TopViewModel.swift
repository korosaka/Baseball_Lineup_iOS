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
    
    private let productIds = ["all_hitter_rule"]
    private let allHitterIndex = 0
    
    func informOrderType(segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goOrderScreen" {
            let tabBarController = segue.destination as! CustomTabBarController
            tabBarController.viewModel?.orderType = sender as? OrderType
        }
    }
    
    func getAllHitterProduct(completion: @escaping (Result<Product, Error>) -> Void) async {
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
            Task {@MainActor in
                completion("エラー", "復元が失敗しました。")
            }
            return
        }
        
        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result else {
                continue
            }
            if transaction.productID == productIds[allHitterIndex] {
                UsingUserDefaults.purchasedSpecial()
                completion("完了", "購入履歴の復元が完了いたしました。")
                return
            }
        }
        
        Task {@MainActor in
            completion("完了", "対象の購入履歴はありませんでした。")
        }
    }
    
    func purchaseItem(_ product: Product, completion: @escaping (String, String) -> Void) async {
        var title = ""
        var message = ""
        do {
            //TODO: handle alert!
            let result = try await product.purchase()
            switch result {
            case let .success(.verified(transaction)):
                await transaction.finish()
                UsingUserDefaults.purchasedSpecial()
                title = "完了"
                message = "購入が完了いたしました。\nありがとうございました。"
            case let .success(.unverified(_, error)):
                //TODO:
                break
            case .pending:
                title = "保留"
                message = "購入は保留されています。"
            case .userCancelled:
                title = "キャンセル"
                message = "購入は中止されました。"
            @unknown default:
                title = "エラー"
                message = "購入に失敗しました。\nまたお時間をおいてお試しください。"
            }
        } catch _ {
            title = "エラー"
            message = "購入に失敗しました。\nまたお時間をおいてお試しください。"
        }
        completion(title, message)
    }
    
    func getSpecialOrderButttonText(purchased: Bool) -> String {
        if purchased {
            return "全員打ち"
        } else {
            return "全員打ち(有料)"
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
