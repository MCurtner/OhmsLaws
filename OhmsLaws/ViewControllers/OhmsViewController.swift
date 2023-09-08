//
//  ViewController.swift
//  OhmsLaws
//
//  Created by Matthew Curtner on 9/3/16.
//  Copyright © 2016 Matthew Curtner. All rights reserved.
//

import UIKit

class OhmsViewController: UIViewController {
    @IBOutlet weak var voltageTextField: UITextField!
    @IBOutlet weak var currentTextField: UITextField!
    @IBOutlet weak var resistanceTextField: UITextField!
    @IBOutlet weak var powerTextField: UITextField!
    @IBOutlet weak var logo: UIImageView!
    
    var blurEffect: UIBlurEffect!
    var blurEffectView: UIVisualEffectView!
    
    // Allowing for user defined rounding
    //var roundingNum: Int!
    var showAds: Bool!
    
    // Array to store the last 2 active textfield tag numbers
    // Initally set to [-1, -1]
    var lastUsedArray: [Int] = [-1, -1]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showLogo()
        SettingsController.shared.createDefaults()
        
        // Setting UITextField Delegate
        voltageTextField.delegate = self
        currentTextField.delegate = self
        resistanceTextField.delegate = self
        powerTextField.delegate = self
        
        displayAd()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //ohmsController.roundingNum = SettingsController.shared.readDefaultForRounding()
        createBlurView()
    }
    
    /// Set the UIStatusBarStyle to display the light color
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func displayAd() {
        let adBanner = AdBanner(toViewController: self, at: .bottom, withOrientation: .portrait, withVolumeRatio: 0.1, timeInterval: 5, showOnRecieve: true, reloadOnError: true)
        showAds = SettingsController.shared.readDefaultForAds()
        print(showAds)
        
        if showAds == true {
            // Add the Ad Banner to the view
            adBanner.load()
            adBanner.show()
            print("showing")
        }
    }
    
    func showLogo() {
        if UIDevice.current.screenType == .iPhone4_4S {
            logo.isHidden = true
        } else {
            print(UIDevice.current.screenType)
        }
    }
    
    func createBlurView() {
        blurEffect = UIBlurEffect(style: .dark)
        blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        blurEffectView.frame = self.view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        blurEffectView.isHidden = true
        
        self.view.addSubview(blurEffectView)
    }
    
    // MARK: - Reset Button
    /// Button to reset all fields to default of '0'.
    /// Set the lastUsedArray to -1, -1
    /// Set all text fields to non active
    ///
    /// - parameter sender: UIButton
    @IBAction func resetBtnWasPressed(_ sender: UIButton) {
        // Set all text field text to '0'
        voltageTextField.text = "0"
        currentTextField.text = "0"
        resistanceTextField.text = "0"
        powerTextField.text = "0"
        
        // Remove all elements in array and
        // append the new elements of -1, -1
        lastUsedArray.removeAll()
        lastUsedArray.append(-1)
        lastUsedArray.append(-1)
        
        // Set text fields color to black
        checkIfFieldTagIsActive(textField: voltageTextField)
        checkIfFieldTagIsActive(textField: currentTextField)
        checkIfFieldTagIsActive(textField: resistanceTextField)
        checkIfFieldTagIsActive(textField: powerTextField)
    }
    
    /// Dismiss keyboard when background touched
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - Array Helper
    /// Add the UITextField Tag values into the array.
    /// If the array count is 2, pop the first index and append
    /// new value.
    /// - parameter value: Tag number of the UITextfield
    func addAndPopArrayValues(value: Int) {
        // Check if the array contains 2 or more elements
        // and if true, remove the first element, then append
        if lastUsedArray.count >= 2 {
            
            // Check that the same tag number will not be added twice
            if value != lastUsedArray[1] {
                lastUsedArray.remove(at: 0)
                lastUsedArray.append(value)
            }
        } else {
            lastUsedArray.append(value)
        }
    }
    
    // MARK: - Calculate
    /// Solve based on the active text fields
    func calculate() {
        
        // Ensure array contains both tags
        // and both elements are not equal to -1 {
        if lastUsedArray[0] != -1 && lastUsedArray[1] != -1 {
            
            let idx0 = lastUsedArray[0]
            let idx1 = lastUsedArray[1]
            
            //Local declaration of variables
            let v: Double = voltageTextField.text!.doubleValue
            let i: Double = currentTextField.text!.doubleValue
            let r: Double = resistanceTextField.text!.doubleValue
            let p: Double = powerTextField.text!.doubleValue
            
            var ohms: Ohms?
        
            // 0 - Voltage plus other fields
            if idx0 == 0 && idx1 == 1 || idx0 == 1 && idx1 == 0 {
                ohms = Ohms(volts: v, amps: i, ohms: nil, watts: nil)
            }
            if idx0 == 0 && idx1 == 2 || idx0 == 2 && idx1 == 0 {
                ohms = Ohms(volts: v, amps: nil, ohms: r, watts: nil)
            }
            if idx0 == 0 && idx1 == 3 || idx0 == 3 && idx1 == 0 {
                ohms = Ohms(volts: v, amps: nil, ohms: nil, watts: p)
            }
            
            // 1 - Amps plus other field
            if idx0 == 1 && idx1 == 2 || idx0 == 2 && idx1 == 1 {
                ohms = Ohms(volts: nil, amps: i, ohms: r, watts: nil)
            }
            if idx0 == 1 && idx1 == 3 || idx0 == 3 && idx1 == 1 {
                ohms = Ohms(volts: nil, amps: i, ohms: nil, watts: p)
            }
            
            // 2 - Resistance plus other field
            if idx0 == 2 && idx1 == 3 || idx0 == 3 && idx1 == 2 {
                ohms = Ohms(volts: nil, amps: nil, ohms: r, watts: p)
            }

            let oc = OhmsController(object: ohms)
            setTextFieldValues(ohms: oc.calculate())
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        blurEffectView.isHidden = false
        
        let vc = segue.destination as! SettingVC
        vc.modalPresentationStyle = .overCurrentContext
        vc.blurViewDelegate = self
    }
}

extension OhmsViewController: UITextFieldDelegate {
    
    // MARK: - UITextField Delegate Methods
    
    /// Necessary steps when user selects the UITectField.
    /// 1. Add/Remove the UITextField Tag numbers to the lastUsedArray.
    /// 2. Highlight the correct active fields
    ///
    /// - parameter textField: Selected UITextField
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Add selected text field tag numbers to the array
        addAndPopArrayValues(value: textField.tag)
        
        // Set the text field border color if listed in the array
        checkIfFieldTagIsActive(textField: voltageTextField)
        checkIfFieldTagIsActive(textField: currentTextField)
        checkIfFieldTagIsActive(textField: resistanceTextField)
        checkIfFieldTagIsActive(textField: powerTextField)
    }
    
    /// Necessary steps when user deselects the UITectField.
    /// 1. Check that the textfield is never nil or empty
    /// 2. Execute calculate()
    ///
    /// - parameter textField: Selected UITextField
    func textFieldDidEndEditing(_ textField: UITextField) {
        // Check that the edited text field is not empty or nil
        // If so, set the value to '0'
        if textField.text == "" || textField.text == nil {
            textField.text = "0"
        }
        
        // Convert the text in the textfield to a decimal formated string
        textField.text = textField.text?.doubleValue.toString()
        
        // Calculate the entered values
        calculate()
        
    }
    
    /// Allow only 1 decimal in text
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let number = CharacterSet.decimalDigits.isSuperset(of: CharacterSet(charactersIn: string))
        return number || (string == NumberFormatter().decimalSeparator && textField.text?.contains(string) == false)
    }
    
    // MARK: - Field Highlighting
    /// Set the border color and border width for the test field
    ///
    /// - parameter textField: Current selected UITextField
    func colorizeActiveFields(textField: UITextField) {
        textField.layer.borderWidth = 2.0
        textField.layer.borderColor = UIColor.orange.cgColor
        textField.layer.cornerRadius = 5
    }
    
    /// Set the border color and width for the inactive fields
    ///
    /// - parameter textField: Current selected UITextField
    func decolorizeTextFields(textField: UITextField) {
        // Set text field back to default color, border and corners
        textField.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 5
    }
    
    /// Colorize/Decolorize the border color/width based on tag number
    ///
    /// - parameter textField: Current selected UITextField
    func checkIfFieldTagIsActive(textField: UITextField) {
        if textField.tag == lastUsedArray[0] || textField.tag == lastUsedArray[1] {
            colorizeActiveFields(textField: textField)
        } else {
            decolorizeTextFields(textField: textField)
        }
    }
    
    func setTextFieldValues(ohms: Ohms) {
        let roundingDigit = SettingsController.shared.readDefaultForRounding()
        
        voltageTextField.text = ohms.volts?.roundToDecimal(roundingDigit).toString()
        currentTextField.text = ohms.amps?.roundToDecimal(roundingDigit).toString()
        resistanceTextField.text = ohms.ohms?.roundToDecimal(roundingDigit).toString()
        powerTextField.text = ohms.watts?.roundToDecimal(roundingDigit).toString()
    }
}

extension OhmsViewController: BlurViewDelegate {
    func setBlurViewHidden() {
        UIView.animate(withDuration: 0.25) {
            self.blurEffectView.removeFromSuperview()
            self.createBlurView()
        }
    }
}
