//
//  SettingsController.swift
//  OhmsLaws
//
//  Created by Matthew Curtner on 8/8/18.
//  Copyright © 2018 Matthew Curtner. All rights reserved.
//

import Foundation

class SettingsController {
    
    static let shared = SettingsController()
    fileprivate var defaults = UserDefaults.standard
    
    /// Create the Default values
    func createDefaults() {
        if defaults.object(forKey: "RoundTo") == nil {
            setRoundingDigitValue(roundingDigit: 2)
        }
        
        if defaults.object(forKey: "Show Ads") == nil {
            defaults.set(true, forKey: "Show Ads")
        }
    }
    
    /// Read the User/Default values and set the roundingNum value
    func readDefaultForAds() -> Bool {
        return defaults.bool(forKey: "Show Ads")
    }
    
    func readDefaultForRounding() -> Int {
        return defaults.integer(forKey: "RoundTo")
    }
    
    func setRoundingDigitValue(roundingDigit: Int) {
        defaults.set(roundingDigit, forKey: "RoundTo")
    }
    
    func setShowAdsValue(showAds: Bool) {
        defaults.set(showAds, forKey: "Show Ads")
    }
}
