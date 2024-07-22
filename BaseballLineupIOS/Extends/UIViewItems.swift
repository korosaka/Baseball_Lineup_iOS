//
//  UIViewItems.swift
//  BaseballLineupIOS
//
//  Created by 坂公郎 on 2024/07/11.
//  Copyright © 2024 Koro Saka. All rights reserved.
//

import UIKit
extension UIButton {
    func setAvailability(isEnabled: Bool, backgroundColor: UIColor) {
        self.isEnabled = isEnabled
        if isEnabled {
            setTitleColor(.white, for: .normal)
            self.backgroundColor = backgroundColor
        } else {
            setTitleColor(.lightGray, for: .normal)
            self.backgroundColor = .gray
        }
    }
    
    func addNumButtonDesign() {
        layer.cornerRadius = 15
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 2
        layer.shadowOpacity = 0.7
        layer.shadowRadius = 2
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 3, height: 3)
    }
    
    func addOperationButtonDesign() {
        layer.cornerRadius = 10
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 2
        layer.shadowOpacity = 0.7
        layer.shadowRadius = 3
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 5, height: 5)
    }
    
    func addLargeButtonDesign() {
        layer.cornerRadius = 15
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 2
        layer.shadowOpacity = 0.7
        layer.shadowRadius = 2
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 3, height: 3)
    }
}
