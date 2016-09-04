//
//  ViewController.swift
//  OhmsLaws
//
//  Created by Matthew Curtner on 9/3/16.
//  Copyright © 2016 Matthew Curtner. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ViewController: UIViewController, GADBannerViewDelegate, UITextFieldDelegate {
    @IBOutlet weak var bannerView: GADBannerView!
    @IBOutlet weak var voltageTextField: UITextField!
    @IBOutlet weak var currentTextField: UITextField!
    @IBOutlet weak var resistanceTextField: UITextField!
    @IBOutlet weak var powerTextField: UITextField!
    
    // Allowing for user defined rounding
    var roundingNum: Int!
    
    // Array to store the last 2 active textfield tag numbers
    // Initally set to [-1, -1]
    var lastUsedArray: [Int] = [-1, -1]
        
   override func viewDidLoad() {
        super.viewDidLoad()
    
        createDefaults()
    
        // Setting UITextField Delegate
        voltageTextField.delegate = self
        currentTextField.delegate = self
        resistanceTextField.delegate = self
        powerTextField.delegate = self
    
        // Display adMob Banner
        displayBanner()
    
        // Read the default values
        readUserValues()
    }
    
    /// Create the Default values
    func createDefaults() {
        let defaults = UserDefaults.standard
        
        if defaults.object(forKey: "RoundTo") == nil {
            //print("Key was nil Setting Default Rounding Number")
            defaults.set(4, forKey: "RoundTo")
        }
        if defaults.object(forKey: "ActiveColor") == nil {
            //print("Setting Default Active Color")
            defaults.setColor(value: UIColor.red, forKey: "ActiveColor")
        }
    }
    
    /// Read the User/Default values and set the roundingNum value
    func readUserValues() {
         let defaults = UserDefaults.standard
        roundingNum = defaults.integer(forKey: "RoundTo")
    }
    
    // MARK: - Reset Button
    /// Button to reset all fields to default of '0'.
    /// Set the lastUsedArray to -1, -1
    /// Set all text fields to non active
    ///
    /// - parameter sender: <#sender description#>
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
    
    /// Set the UIStatusBarStyle to display the light color
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Ad Banner
    /// Setup and display the Banner Ad from AdMob.
    func displayBanner() {
        let request = GADRequest();
        request.testDevices = [kGADSimulatorID]
        
        bannerView.delegate = self
        bannerView.adUnitID = "ca-app-pub-9801328113033460/3521494233"
        bannerView.rootViewController = self
        bannerView.load(request)
    }
    
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
        
        // Calculate the entered values
        calculate()
    }
    
    // Dismiss keyboard when background touched
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    // MARK: - Field Highlighting
    
    /// Set the border color and border width for the test field
    ///
    /// - parameter textField: Current selected UITextField
    func colorizeActiveFields(textField: UITextField) {
        textField.layer.borderWidth = 2.0
        textField.layer.borderColor = UIColor.red.cgColor
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
        if lastUsedArray.count > 1 {
            let idx0 = lastUsedArray[0]
            let idx1 = lastUsedArray[1]
            
            let v: Double = Double(voltageTextField.text!)!
            let i: Double = Double(currentTextField.text!)!
            let r: Double = Double(resistanceTextField.text!)!
            let p: Double = Double(powerTextField.text!)!
            
            // 0 - Voltage plus other fields
            if idx0 == 0 && idx1 == 1 || idx0 == 1 && idx1 == 0 {
                resistanceTextField.text = String(calculateResistance(voltage:v, amps: i))
                powerTextField.text = String(calculateWatts(voltage: v, amps: i))
            }
            if idx0 == 0 && idx1 == 2 || idx0 == 2 && idx1 == 0 {
                currentTextField.text = String(calculateAmps(voltage: v, resistance: r))
                powerTextField.text = String(calculateWatts(voltage: v, resistance: r))
            }
            if idx0 == 0 && idx1 == 3 || idx0 == 3 && idx1 == 0 {
                currentTextField.text = String(calculateAmps(power: p, voltage: v))
                resistanceTextField.text = String(calculateResistance(voltage: v, power: p))
            }
            
            // 1 - Amps plus other field
            if idx0 == 1 && idx1 == 2 || idx0 == 2 && idx1 == 1 {
                voltageTextField.text = String(calculateVoltage(amp: i, resistance: r))
                powerTextField.text = String(calculateWatts(resistance: r, amps: i))
            }
            if idx0 == 1 && idx1 == 3 || idx0 == 3 && idx1 == 1 {
                voltageTextField.text = String(calculateVoltage(amps: i, power: p))
                resistanceTextField.text = String(calculateResistance(power: p, amps: i))
            }
            
            // 2 - Resistance plus other field
            if idx0 == 2 && idx1 == 3 || idx0 == 3 && idx1 == 2 {
                voltageTextField.text = String(calculateVoltage(power: p, resistance: r))
                currentTextField.text = String(calculateAmps(power: p, resistance: r))
            }
        }
    }
   
    // MARK: - Algorithms/Laws
    
    // MARK: - Voltage
    /// Calculate Voltage based on known Amp and Resistance values
    ///
    /// - parameter amp:        Double value of user input of Amp
    /// - parameter resistance: Double value of user input of Resistance
    ///
    /// - returns: Double value of Voltage value rounded to specifed decimal
    func calculateVoltage(amp: Double, resistance: Double) -> Double {
        return (resistance * amp).roundToPlaces(places: roundingNum)
    }
    
    /// Calculate Voltage based on known Amp and Watt values
    ///
    /// - parameter amps:  Double value of user input of Amp
    /// - parameter power: Double value of user input of Watt
    ///
    /// - returns: Double value of Voltage value rounded to specifed decimal
    func calculateVoltage(amps: Double, power: Double) -> Double {
        return (power / amps).roundToPlaces(places: roundingNum)
    }
    
    /// Calculate Voltage based on known Watt and Resistance values
    ///
    /// - parameter power:      Double value of user input of Watt
    /// - parameter resistance: Double value of user input of Resistance
    ///
    /// - returns: Double value of Voltage value rounded to specifed decimal
    func calculateVoltage(power: Double, resistance: Double) -> Double {
        return sqrt(power * resistance).roundToPlaces(places: roundingNum)
    }
    
    // MARK: - Amps
    /// Calculate Amps based on known Voltage and Resistance values
    ///
    /// - parameter voltage:    Double value of user input of Voltage
    /// - parameter resistance: Double value of user input of Resistance
    ///
    /// - returns: Double value of Amps value rounded to specifed decimal
    func calculateAmps(voltage: Double, resistance: Double) -> Double {
        return (voltage / resistance).roundToPlaces(places: roundingNum)
    }
    
    /// Calculate Amps based on known Voltage and Watts values
    ///
    /// - parameter power:      Double value of user input of Watts
    /// - parameter voltage:    Double value of user input of Voltage
    ///
    /// - returns: Double value of Amps value rounded to specifed decimal
    func calculateAmps(power: Double, voltage: Double) -> Double {
        return power / voltage
    }
    
    /// Calculate Amps based on known Voltage and Amps values
    ///
    /// - parameter power:      Double value of user input of Voltage
    /// - parameter resistance: Double value of user input of Resistance
    ///
    /// - returns: Double value of Amps value rounded to specifed decimal
    func calculateAmps(power: Double, resistance: Double) -> Double {
        return sqrt(power / resistance).roundToPlaces(places: roundingNum)
    }
    
    // MARK: - Resistance
    /// Calculate Resistance based on known Voltage and Amps values
    ///
    /// - parameter voltage: Double value of user input of Voltage
    /// - parameter amps:    Double value of user input of Amps
    ///
    /// - returns: Double value of Resistance value rounded to specifed decimal
    func calculateResistance(voltage: Double, amps: Double) -> Double {
        return (voltage / amps).roundToPlaces(places: roundingNum)
    }
    
    /// Calculate Resistance based on known Voltage and Watt values
    ///
    /// - parameter voltage: Double value of user input of Voltage
    /// - parameter power:   Double value of user input of Watts
    ///
    /// - returns: Double value of Resistance value rounded to specifed decimal
    func calculateResistance(voltage: Double, power: Double) -> Double {
        return  (pow(voltage, 2.0) / power).roundToPlaces(places: roundingNum)
    }
    
    /// Calculate Resistance based on known Watts and Amps values
    ///
    /// - parameter power: Double value of user input of Watts
    /// - parameter amps:  Double value of user input of Amps
    ///
    /// - returns: Double value of Resistance value rounded to specifed decimal
    func calculateResistance(power: Double, amps: Double) -> Double {
        return (power / pow(amps, 2.0)).roundToPlaces(places: roundingNum)
    }
    
    // MARK: - Watts
    /// Calculate Watts based on known Voltage and Amps values
    ///
    /// - parameter voltage: Double value of user input of Voltage
    /// - parameter amps:    Double value of user input of Resistance
    ///
    /// - returns: Double value of Watt value rounded to specifed decimal
    func calculateWatts(voltage: Double, amps: Double) -> Double {
        return (voltage * amps).roundToPlaces(places: roundingNum)
    }
    
    /// Calculate Watts based on known Resistance and Amps values
    /// - parameter resistance: Double value of user input of Resistance
    /// - parameter amps:       Double value of user input of Amps
    ///
    /// - returns: Double value of Watts value rounded to specifed decimal
    func calculateWatts(resistance: Double, amps: Double) -> Double {
        return (resistance * pow(amps, 2.0)).roundToPlaces(places: roundingNum)
    }
    
    /// Calculate Watts based on known Voltage and Resistance values
    /// - parameter voltage:    Double value of user input of Voltage
    /// - parameter resistance: Double value of user input of Resistance
    ///
    /// - returns: Double value of Watt value rounded to specifed decimal
    func calculateWatts(voltage: Double, resistance: Double) -> Double {
        return (pow(voltage, 2.0) / resistance).roundToPlaces(places: roundingNum)
    }
}


// MARK: - Round 'Double' value to desired decimal place
extension Double {
    /// Rounds the double to decimal places value
    func roundToPlaces(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}


// MARK: - Extension to store and retrieve UIColor in UserDefaults
extension UserDefaults {
    func setColor(value: UIColor!, forKey: String) {
        guard let value = value else {
            UserDefaults().set(nil, forKey:  forKey)
            return
        }
        UserDefaults().set(NSKeyedArchiver.archivedData(withRootObject: value), forKey: forKey)
    }
    func colorForKey(key:String) -> UIColor? {
        guard let data = UserDefaults().data(forKey: key),
            let color = NSKeyedUnarchiver.unarchiveObject(with: data) as? UIColor
            else { return nil }
        return color
    }
}


