//
//  SettingVC.swift
//  OhmsLaws
//
//  Created by Matthew Curtner on 9/4/16.
//  Copyright © 2016 Matthew Curtner. All rights reserved.
//

import UIKit

protocol BlurViewDelegate {
    func setBlurViewHidden()
}

class SettingVC: UIViewController {
    
    @IBOutlet weak var roundingTextField: UITextField!
    @IBOutlet weak var removeAdsButton: UIButton!
    @IBOutlet weak var settingsView: UIView!
    
    var keyboardIsDisplayed: Bool = false
    var blurViewDelegate: BlurViewDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingsView.layer.cornerRadius = 8
        removeAdsButton.layer.cornerRadius = 3
        
        roundingTextField.delegate = self
        
        // Load the user defaults
        roundingTextField.text = "\(SettingsController.shared.readDefaultForRounding())"
        
        IAPHandler.shared.fetchAvailableProducts()
        IAPHandler.shared.purchaseStatusBlock = { [weak self] (type) in
            guard let strongSelf = self else {return}
            
            if type == .purchased {
                let alertView = UIAlertController(title: "", message: type.message(), preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alertView.addAction(action)
                strongSelf.present(alertView, animated: true, completion: nil)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Create notifications for UIKeyboard appearing and disappearing
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
    }
    
    @objc func keyboardWillAppear() {
        keyboardIsDisplayed = true
    }
    
    @objc func keyboardWillDisappear() {
        keyboardIsDisplayed = false
    }

    /// Dismiss keyboard if background is touched
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if keyboardIsDisplayed == true {
            print(keyboardIsDisplayed)
            self.view.endEditing(true)
        } else {
            SettingsController.shared.setRoundingDigitValue(roundingDigit: Int(roundingTextField.text!)!)
            dismiss(animated: true) {
                self.blurViewDelegate?.setBlurViewHidden()
            }
        }
    }

    // MARK: - Actions
    
    /// Restore Purchases
    @IBAction func removeAdsBtnWasPressed(_ sender: UIButton) {
        IAPHandler.shared.purchaseProduct(index: 0)
    }
}


extension SettingVC: UITextFieldDelegate {
    
    // MARK: - UITextField Delegate Method
    /// Prevent user from inserting more than 1 character
    /// in the roundingTextField.
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
        let currentCharacterCount = textField.text?.count ?? 0
        if (range.length + range.location > currentCharacterCount){
            return false
        }
        
        let newLength = currentCharacterCount + string.count - range.length
        return newLength <= 1
    }
    
    // Prevent the textfield from being left empty
    func textFieldDidEndEditing(_ textField: UITextField) {
        // Check that the edited text field is not empty or nil
        // If so, set the value to '0'
        if textField.text == "" || textField.text == nil {
            textField.text = "0"
        }
    }
}
