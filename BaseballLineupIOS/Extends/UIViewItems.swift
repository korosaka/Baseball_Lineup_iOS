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
}
