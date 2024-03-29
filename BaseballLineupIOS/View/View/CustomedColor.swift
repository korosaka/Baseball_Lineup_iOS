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
    static var catcherColor: UIColor { return UIColor(red: 30.0 / 255.0, green: 144.0 / 255.0, blue: 1.0, alpha: 1.0) }
    static var infielderColor: UIColor { return UIColor(red: 252.0 / 255.0, green: 200.0 / 255.0, blue: 0.0, alpha: 1.0) }
    static var outfielderColor: UIColor { return UIColor(red: 0.0, green: 204.0 / 255.0, blue: 0.0, alpha: 1.0) }
    static var dhColor: UIColor { return UIColor(red: 175.0 / 255.0, green: 96.0 / 255.0, blue: 1.0, alpha: 1.0) }
    static var orderNumColor: UIColor { return UIColor(red: 169.0 / 255.0, green: 169.0 / 255.0, blue: 169.0 / 255.0, alpha: 1.0) }
    
    //MARK: for labels on sub player item
    static var pitcherRoleColor: UIColor { return UIColor(red: 255.0 / 255.0, green: 56.0 / 255.0, blue: 56.0 / 255.0, alpha: 1.0) }
    static var hitterRoleColor: UIColor { return UIColor(red: 20.0 / 255.0, green: 1.0, blue: 20.0 / 255.0, alpha: 1.0) }
    static var runnerRoleColor: UIColor { return UIColor(red: 127.0 / 255.0, green: 191.0 / 255.0, blue: 1.0, alpha: 1.0) }
    static var fielderRoleColor: UIColor { return UIColor(red: 1.0, green: 1.0, blue: 0.0 / 255.0, alpha: 1.0) }
    static var offTextColor: UIColor { return UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.3) }
}
