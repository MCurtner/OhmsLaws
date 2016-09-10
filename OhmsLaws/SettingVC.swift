//
//  SettingVC.swift
//  OhmsLaws
//
//  Created by Matthew Curtner on 9/4/16.
//  Copyright © 2016 Matthew Curtner. All rights reserved.
//

import UIKit
import StoreKit

class SettingVC: UIViewController, UITextFieldDelegate, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    @IBOutlet weak var roundingTextField: UITextField!
    @IBOutlet weak var removeAdsButton: UIButton!
    
    let productIdentifiers = Set(["com.matthewcurtner.OhmsLaws.AdRemoval","com.matthewcurtner.OhmsLaws.Test"])
    var product: SKProduct?
    var productsArray: [SKProduct] = []
    
    var showAds: Bool = true
    var roundingDigit: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        roundingTextField.delegate = self
        
        //Register class with SKPaymentTransactionObserver delegate
        SKPaymentQueue.default().add(self)
        
        requestProductData()
        
        // Load the user defaults
        readUserDefaults()
        roundingTextField.text = "\(roundingDigit!)"
        
        removeAdsButton.isEnabled = false
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Close the SKPayment queue
        SKPaymentQueue.default().remove(self)
        
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
    /// Retrieve the User/Default values for view
    func readUserDefaults() {
        let defaults = UserDefaults.standard
        roundingDigit = defaults.integer(forKey: "RoundTo")
        showAds = defaults.bool(forKey: "Show Ads")
    }
    
    /// Set the User/Default values for rounding decimal
    func setUserDefaults() {
        let defaults = UserDefaults.standard
        roundingDigit = Int(roundingTextField.text!)
        defaults.set(roundingDigit, forKey: "RoundTo")
    }
    
    // MARK: - Actions
    /// Dismiss Setting VC without saving
    @IBAction func cancelBtnWasPressed(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }

    /// Dismiss Setting VC while saving changes
    @IBAction func saveBtnWasPressed(_ sender: AnyObject) {
        setUserDefaults()
        dismiss(animated: true, completion: nil)
    }
    
    /// Restore Purchases
    @IBAction func removeAdsBtnWasPressed(_ sender: UIButton) {
        let payment = SKPayment(product: self.productsArray[0])
        SKPaymentQueue.default().add(payment)
    }

    /// Restore Purchases
    @IBAction func restorePurchases(_ sender: UIButton) {
      
    }
    
    // MARK: - IAP
    ///
    func requestProductData() {
        // Check if the user can make a payment
        if SKPaymentQueue.canMakePayments() {
            let request = SKProductsRequest(productIdentifiers: productIdentifiers)
            request.delegate = self
            request.start()
        } else {
            displayAlert()
        }
    }
    
    func displayAlert() {
        let alert = UIAlertController(title: "In App Purchases disabled.",
                                      message: "Please enable In App Purchases in Settings.",
                                      preferredStyle: .alert)
        
        // Add 'Settings' button action
        // Will open settings app if possible
        alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { (alertAction) in
            alert.dismiss(animated: true, completion: nil)
            
            let url = URL(string: UIApplicationOpenSettingsURLString)
            if url != nil {
                UIApplication.shared.openURL(url!)
            }
        }))
        
        // Add 'OK' button action
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (alertAction) in
            alert.dismiss(animated: true, completion: nil)
        }))
    }
    
    func enableButton(button: UIButton) {
        button.isEnabled = true
    }
    
    /// SKProductsRequestDelegate Method
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        let products = response.products
        
        if products.count != 0 {
            for i in 0 ..< products.count {
                self.product = products[i]
                self.productsArray.append(self.product!)
            }
        } else {
            print("No products found")
        }
        
        // Enable Buttons is product array contains
        // product identifiers
        if self.productsArray.count != 0 {
            enableButton(button: removeAdsButton)
        }
        
        let invalidProducts = response.invalidProductIdentifiers
        
        for item in invalidProducts {
            print("Product not found: \(item)")
        }
    }
    

    // Ensure payments has been made for the removal of ads
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                print("Transaction Approved for : \(transaction.payment.productIdentifier)")
                self.deliverProduct(transaction: transaction)
                SKPaymentQueue.default().finishTransaction(transaction)
            case .failed:
                print("Transacation Failed")
                SKPaymentQueue.default().finishTransaction(transaction)
            default:
                break
            }
        }
    }
    
    // Deliver the functionality paid for: Remove Ads
    func deliverProduct(transaction: SKPaymentTransaction) {
        if transaction.payment.productIdentifier == "com.matthewcurtner.OhmsLaws.AdRemoval" {
            let defaults = UserDefaults.standard
            showAds = false
            defaults.set(false, forKey: "Show Ads")
        }
    }
    
    
    
}
