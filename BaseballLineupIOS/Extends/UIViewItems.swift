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
        layer.borderColor = UIColor.darkGray.cgColor
        layer.borderWidth = 1
        layer.shadowOpacity = 0.7
        layer.shadowRadius = 2
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 3, height: 3)
    }
    
    func addOperationButtonDesign() {
        layer.cornerRadius = 10
        layer.borderColor = UIColor.lightGray.cgColor
        layer.borderWidth = 1
        layer.shadowOpacity = 0.7
        layer.shadowRadius = 3
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 5, height: 5)
    }
    
    func addLargeButtonDesign() {
        layer.cornerRadius = 15
        layer.borderColor = UIColor.darkGray.cgColor
        layer.borderWidth = 1
        layer.shadowOpacity = 0.7
        layer.shadowRadius = 2
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 3, height: 3)
    }
}

///ref: https://qiita.com/bu-ka/items/afda427e8dbe03e8e3a2
class DecorateLabel: UILabel {
    
    var strokeColor:UIColor = UIColor.white
    var strokeSize:CGFloat = 2.0

    override func drawText(in rect: CGRect) {
        if let context = UIGraphicsGetCurrentContext() {
            let textColor = self.textColor

            context.setLineWidth(self.strokeSize)
            context.setLineJoin(CGLineJoin.round)
            context.setTextDrawingMode(.stroke)
            self.textColor = self.strokeColor
            super.drawText(in: rect)

            context.setTextDrawingMode(.fill)
            self.textColor = textColor
        }
        super.drawText(in: rect)
    }
}
