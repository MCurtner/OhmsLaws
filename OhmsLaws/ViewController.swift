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
    let roundingNum: Int = 5
    
    // Array to store the last 2 active textfield tag numbers
    // Initally set to [-1, -1]
    var lastUsedArray: [Int] = [-1, -1]
        
   override func viewDidLoad() {
        super.viewDidLoad()

        // Setting UITextField Delegate
        voltageTextField.delegate = self
        currentTextField.delegate = self
        resistanceTextField.delegate = self
        powerTextField.delegate = self
    
        // Display adMob Banner
        displayBanner()
        
    }

    // MARK: - Reset Button
    @IBAction func resetBtnWasPressed(_ sender: AnyObject) {
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
    

    // MARK: - Ad Banner
    func displayBanner() {
        let request = GADRequest();
        request.testDevices = [kGADSimulatorID]
        
        bannerView.delegate = self
        bannerView.adUnitID = "ca-app-pub-9801328113033460/3521494233"
        bannerView.rootViewController = self
        bannerView.load(request)
    }
    
    // MARK: - UITextField Delegate Methods
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Add selected text field tag numbers to the array
        addAndPopArrayValues(value: textField.tag)

        // Set the text field border color if listed in the array
        checkIfFieldTagIsActive(textField: voltageTextField)
        checkIfFieldTagIsActive(textField: currentTextField)
        checkIfFieldTagIsActive(textField: resistanceTextField)
        checkIfFieldTagIsActive(textField: powerTextField)
    }
    
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
    
    // Set the border color and width for the active fields
    func colorizeActiveFields(textField: UITextField) {
        textField.layer.borderWidth = 2.0
        textField.layer.borderColor = UIColor.red.cgColor
    }
    
    // Set the border color and width for the inactive fields
    func decolorizeTextFields(textField: UITextField) {
        // Set text field back to default color, border and corners
        textField.layer.borderColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0).cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 5
    }
    
    // Set the border color/width based on tag number
    func checkIfFieldTagIsActive(textField: UITextField) {
        if textField.tag == lastUsedArray[0] || textField.tag == lastUsedArray[1] {
            colorizeActiveFields(textField: textField)
        } else {
            decolorizeTextFields(textField: textField)
        }
    }
    
    
    // MARK: - Array Helper
    // Add the UITextField Tag values into the array
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
    // Solve based on the active text fields
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
    
    // Voltage
    func calculateVoltage(amp: Double, resistance: Double) -> Double {
        return (resistance * amp).roundToPlaces(places: roundingNum)
    }
    
    func calculateVoltage(amps: Double, power: Double) -> Double {
        return (power / amps).roundToPlaces(places: roundingNum)
    }
    
    func calculateVoltage(power: Double, resistance: Double) -> Double {
        print("\(sqrt(power * resistance).roundToPlaces(places: roundingNum))")
        return sqrt(power * resistance).roundToPlaces(places: roundingNum)
    }
    
    // Amps
    func calculateAmps(voltage: Double, resistance: Double) -> Double {
        return (voltage / resistance).roundToPlaces(places: roundingNum)
    }
    
    func calculateAmps(power: Double, voltage: Double) -> Double {
        return power / voltage
    }
    
    func calculateAmps(power: Double, resistance: Double) -> Double {
        return sqrt(power / resistance).roundToPlaces(places: roundingNum)
    }
    
    // Resistance
    func calculateResistance(voltage: Double, amps: Double) -> Double {
        return (voltage / amps).roundToPlaces(places: roundingNum)
    }
    
    func calculateResistance(voltage: Double, power: Double) -> Double {
        return  (pow(voltage, 2.0) / power).roundToPlaces(places: roundingNum)
    }
    
    func calculateResistance(power: Double, amps: Double) -> Double {
        return (power / pow(amps, 2.0)).roundToPlaces(places: roundingNum)
    }
    
    // Watts
    func calculateWatts(voltage: Double, amps: Double) -> Double {
        return (voltage * amps).roundToPlaces(places: roundingNum)
    }
    
    func calculateWatts(resistance: Double, amps: Double) -> Double {
        return (resistance * pow(amps, 2.0)).roundToPlaces(places: roundingNum)
    }
    
    func calculateWatts(voltage: Double, resistance: Double) -> Double {
        return (pow(voltage, 2.0) / resistance).roundToPlaces(places: roundingNum)
    }
}


//MARK: - Round 'Double' value to desired decimal place
extension Double {
    /// Rounds the double to decimal places value
    func roundToPlaces(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}


