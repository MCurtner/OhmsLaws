//
//  Extensions.swift
//  OhmsLaws
//
//  Created by Matthew Curtner on 8/10/18.
//  Copyright © 2018 Matthew Curtner. All rights reserved.
//

import UIKit

extension String {
    static let numberFormatter = NumberFormatter()

    var doubleValue: Double {
        String.numberFormatter.decimalSeparator = "."
        if let result =  String.numberFormatter.number(from: self) {
            return result.doubleValue
        } else {
            String.numberFormatter.decimalSeparator = ","
            if let result = String.numberFormatter.number(from: self) {
                return result.doubleValue
            }
        }
        return 0
    }
}

extension Double {
    func toString() -> String {
        return String(format: "%.\(SettingsController().readDefaultForRounding())f",self)
    }
    
    func roundToDecimal(_ fractionDigits: Int) -> Double {
        print(fractionDigits)
        let multiplier = pow(10, Double(fractionDigits))
        return Darwin.round(self * multiplier) / multiplier
    }
}

extension UIDevice {
    var iPhoneX: Bool {
        return UIScreen.main.nativeBounds.height == 2436
    }
    var iPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
    enum ScreenType: String {
        case iPhone4_4S = "iPhone 4 or iPhone 4S"
        case iPhones_5_5s_5c_SE = "iPhone 5, iPhone 5s, iPhone 5c or iPhone SE"
        case iPhones_6_6s_7_8 = "iPhone 6, iPhone 6S, iPhone 7 or iPhone 8"
        case iPhones_6Plus_6sPlus_7Plus_8Plus = "iPhone 6 Plus, iPhone 6S Plus, iPhone 7 Plus or iPhone 8 Plus"
        case iPhoneX = "iPhone X"
        case unknown
    }
    var screenType: ScreenType {
        switch UIScreen.main.nativeBounds.height {
        case 960:
            return .iPhone4_4S
        case 1136:
            return .iPhones_5_5s_5c_SE
        case 1334:
            return .iPhones_6_6s_7_8
        case 1920, 2208:
            return .iPhones_6Plus_6sPlus_7Plus_8Plus
        case 2436:
            return .iPhoneX
        default:
            return .unknown
        }
    }
}

//// MARK: - Round 'Double' value to specified decimal place
//extension Double {
//    func roundToDecimal(_ fractionDigits: Int) -> Double {
//        print(fractionDigits)
//        let multiplier = pow(10, Double(fractionDigits))
//        return Darwin.round(self * multiplier) / multiplier
//    }
//}
