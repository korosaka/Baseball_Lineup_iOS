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
                completion(.success(products[0]))
            }
        } catch {
            completion(.failure(error))
        }
    }
    
    func purchaseItem(_ product: Product, completion: @escaping (String, String) -> Void) async {
        var title = ""
        var message = ""
        do {
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
