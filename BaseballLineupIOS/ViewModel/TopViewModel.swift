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
    
}

enum CustomError: Error {
    case noProductError
}
