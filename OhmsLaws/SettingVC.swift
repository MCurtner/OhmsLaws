//
//  SettingVC.swift
//  OhmsLaws
//
//  Created by Matthew Curtner on 9/4/16.
//  Copyright © 2016 Matthew Curtner. All rights reserved.
//

import UIKit

class SettingVC: UIViewController {
    
    var roundingDigit: Int!
    var activeColor: UIColor!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    /// Retrieve the User/Default values for view and editing
    func readUserDefaults() {
        let defaults = UserDefaults.standard
        roundingDigit = defaults.integer(forKey: "RoundTo")
        activeColor = defaults.colorForKey(key: "ActiveColor")
    }
    
    @IBAction func cancelBtnWasPressed(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func saveBtnWasPressed(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

