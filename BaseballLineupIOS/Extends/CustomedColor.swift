//
//  CustomedColor.swift
//  BaseballLineupIOS
//
//  Created by Koro Saka on 2021-03-20.
//  Copyright © 2021 Koro Saka. All rights reserved.
//

import UIKit
extension UIColor {
    static var pitcherColor: UIColor { return UIColor(red: 1.0, green: 56.0 / 255.0, blue: 56.0 / 255.0, alpha: 1.0) }
    static var pitcherBorderColor: UIColor { return UIColor(red: 201.0 / 255.0, green: 21.0 / 255.0, blue: 30.0 / 255.0, alpha: 1.0) }
    static var catcherColor: UIColor { return UIColor(red: 30.0 / 255.0, green: 144.0 / 255.0, blue: 1.0, alpha: 1.0) }
    static var catcherBorderColor: UIColor { return UIColor(red: 76.0 / 255.0, green: 108.0 / 255.0, blue: 179.0 / 255.0, alpha: 1.0) }
    static var infielderColor: UIColor { return UIColor(red: 255.0 / 255.0, green: 220.0 / 255.0, blue: 0.0 / 255.0, alpha: 1.0) }
    static var infielderBorderColor: UIColor { return UIColor(red: 204.0 / 255.0, green: 153.0 / 255.0, blue: 0.0 / 255.0, alpha: 1.0) }
    static var outfielderColor: UIColor { return UIColor(red: 0.0, green: 204.0 / 255.0, blue: 0.0, alpha: 1.0) }
    static var outfielderBorderColor: UIColor { return UIColor(red: 71.0 / 255.0, green: 136.0 / 255.0, blue: 94.0 / 255.0, alpha: 1.0) }
    static var dhColor: UIColor { return UIColor(red: 175.0 / 255.0, green: 96.0 / 255.0, blue: 1.0, alpha: 1.0) }
    static var dhBorderColor: UIColor { return UIColor(red: 103.0 / 255.0, green: 65.0 / 255.0, blue: 150.0 / 255.0, alpha: 1.0) }
    static var orderNumColor: UIColor { return UIColor(red: 169.0 / 255.0, green: 169.0 / 255.0, blue: 169.0 / 255.0, alpha: 1.0) }
    static var orderNumBorderColor: UIColor { return UIColor(red: 96.0 / 255.0, green: 96.0 / 255.0, blue: 96.0 / 255.0, alpha: 1.0) }
    
    //MARK: for labels on sub player item
    static var pitcherRoleColor: UIColor { return UIColor(red: 255.0 / 255.0, green: 56.0 / 255.0, blue: 56.0 / 255.0, alpha: 1.0) }
    static var hitterRoleColor: UIColor { return UIColor(red: 20.0 / 255.0, green: 1.0, blue: 20.0 / 255.0, alpha: 1.0) }
    static var runnerRoleColor: UIColor { return UIColor(red: 127.0 / 255.0, green: 191.0 / 255.0, blue: 1.0, alpha: 1.0) }
    static var fielderRoleColor: UIColor { return UIColor(red: 1.0, green: 1.0, blue: 0.0 / 255.0, alpha: 1.0) }
    static var offTextColor: UIColor { return UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3) }
    
    //MARK: TOP
    static var dialogColor: UIColor { return UIColor(red: 255.0 / 255.0, green: 255.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0) }
    static var largeButtonColor: UIColor { return UIColor(red: 86.0 / 255.0, green: 170.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0) }
    static var appTitleColor: UIColor { return UIColor(red: 122.0 / 255.0, green: 188.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0) }
    
    //MARK: ORDER TABLE
    static var labelTextColor: UIColor { return UIColor(red: 0.0 / 255.0, green: 51.0 / 255.0, blue: 204.0 / 255.0, alpha: 1.0) }
    static var appBackGroundColor: UIColor { return UIColor(red: 234.0 / 255.0, green: 244.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0) }
    static var textFieldDarkColor: UIColor { return UIColor(red: 127.0 / 255.0, green: 191.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0) }
    static var registeringBoxLightColor: UIColor { return UIColor(red: 86.0 / 255.0, green: 170.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0) }
    static var registeringBoxDarkColor: UIColor { return UIColor(red: 25.0 / 255.0, green: 140.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0) }
    static var operationButtonColor: UIColor { return UIColor(red: 122.0 / 255.0, green: 188.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0) }
    static var numButtonColor: UIColor { return UIColor(red: 25.0 / 255.0, green: 140.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0) }
    static var pickerColor: UIColor { return UIColor(red: 255.0 / 255.0, green: 220.0 / 255.0, blue: 0.0 / 255.0, alpha: 1.0) }
    
    static var allClearButtonColor: UIColor { return UIColor(red: 135.0 / 255.0, green: 15.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0) }
    
    static func dynamicColor(light: UIColor, dark: UIColor) -> UIColor {
        if #available(iOS 13, *) {
            return UIColor { (traitCollection) -> UIColor in
                if traitCollection.userInterfaceStyle == .dark {
                    return dark
                } else {
                    return light
                }
            }
        }
        return light
    }
}
