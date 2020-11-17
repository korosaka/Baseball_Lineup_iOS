//
//  AllReviewViewModel.swift
//  BaseballLineupIOS
//
//  Created by Koro Saka on 2020-11-15.
//  Copyright © 2020 Koro Saka. All rights reserved.
//

import Foundation
import UIKit

class AllReviewViewModel {
    
    weak var delegate: AllReviewViewModelDelegate?
    
    var reviewData: ReviewData
    var selectedReview: Review?
    
    init() {
        reviewData = .init()
        reviewData.delegate = self
    }
    
    
    func getReview(index: Int) -> Review? {
        guard let review: Review? = reviewData.reviews[index] else {
            return nil
        }
        return review
    }
    
    func getReviewCount() -> Int {
        return reviewData.countReview()
    }
    
    func getUserName(index: Int) -> String {
        guard let userName = getReview(index: index)?.user else {
            return ""
        }
        return userName
    }
    
    func getEvaluation(index: Int) -> String {
        guard let evaluation = getReview(index: index)?.evaluation else {
            return String(0)
        }
        return String(evaluation)
    }
    
    func getComment(index: Int) -> String {
        guard let comment = getReview(index: index)?.comment else {
            return ""
        }
        return comment
    }
    
    func getIcon(index: Int) -> UIImage {
        guard let _ = getReview(index: index)?.picture else {
            return UIImage(systemName: "camera")!
        }
        return UIImage(systemName: "camera.fill")!
    }
    
    func selectReview(index: Int) {
        selectedReview = getReview(index: index)
    }
    
    func reloadData() {
        reviewData.reloadReviewData()
    }
}


extension AllReviewViewModel: ReviewDataDelegate {
    func afterReload() {
        delegate?.tableviewRefresh()
    }
}

// MARK: from ViewModel to View
protocol AllReviewViewModelDelegate: class {
    func tableviewRefresh()
}
