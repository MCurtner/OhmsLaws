//
//  NavigationVC.swift
//  OhmsLaws
//
//  Created by Matthew Curtner on 9/11/16.
//  Copyright © 2016 Matthew Curtner. All rights reserved.
//

import UIKit

class NavigationVC: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
    
        let font = UIFont(name: "HelveticaNeue-Light", size: 21)!
        let color = UIColor(red:0.10, green:0.60, blue:0.99, alpha:1.00)
        
        
        let navigationBarAppearace = UINavigationBar.appearance()
        navigationBarAppearace.titleTextAttributes = [NSForegroundColorAttributeName: color,
                                                      NSFontAttributeName: font]
        
    }
}
