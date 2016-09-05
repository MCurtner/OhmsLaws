//
//  SettingVC.swift
//  OhmsLaws
//
//  Created by Matthew Curtner on 9/4/16.
//  Copyright © 2016 Matthew Curtner. All rights reserved.
//

import UIKit

class SettingVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var roundingTextField: UITextField!
    
    var roundingDigit: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        roundingTextField.delegate = self
        
        readUserDefaults()
        roundingTextField.text = "\(roundingDigit!)"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Remove the keyboard when the view will
        // be dismissed.
        self.view.endEditing(true)
    }

    // MARK: - UITextField Delegate Method
    /// Prevent user from inserting more than 1 character
    /// in the roundingTextField.
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentCharacterCount = textField.text?.characters.count ?? 0
        if (range.length + range.location > currentCharacterCount){
            return false
        }
        let newLength = currentCharacterCount + string.characters.count - range.length
        return newLength <= 1
    }
    
    /// Dismiss keyboard if background is touched
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - NSUserDefaults
    /// Retrieve the User/Default values for view and editing
    func readUserDefaults() {
        let defaults = UserDefaults.standard
        roundingDigit = defaults.integer(forKey: "RoundTo")
    }
    
    func setUserDefaults() {
        let defaults = UserDefaults.standard
        roundingDigit = Int(roundingTextField.text!)
        defaults.set(roundingDigit, forKey: "RoundTo")
    }
    
    // MARK: - Actions
    @IBAction func cancelBtnWasPressed(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func saveBtnWasPressed(_ sender: AnyObject) {
        setUserDefaults()
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

