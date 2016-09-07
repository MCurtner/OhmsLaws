//
//  SettingVC.swift
//  OhmsLaws
//
//  Created by Matthew Curtner on 9/4/16.
//  Copyright © 2016 Matthew Curtner. All rights reserved.
//

import UIKit
import StoreKit

class SettingVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var roundingTextField: UITextField!
    
    var productIdentifer = Set(["com.matthewcurtner.AdRemovalTest", "com.matthewcurtner.invalidTest"])
    var product: SKProduct?
    var productsArray: [SKProduct] = []
    
    var roundingDigit: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        roundingTextField.delegate = self
        
        // Load the user defaults
        readUserDefaults()
        roundingTextField.text = "\(roundingDigit!)"
        
        // Re
        //requestProductData()
        
        // Register with delegate
        // SKPaymentQueue.default().add(self)
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
    /// Retrieve the User/Default values for view
    func readUserDefaults() {
        let defaults = UserDefaults.standard
        roundingDigit = defaults.integer(forKey: "RoundTo")
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
        let payment = SKPayment(product: productsArray[0])
        SKPaymentQueue.default().add(payment)
    }
    
    /// Restore Purchases
    @IBAction func restorePurchases(_ sender: UIButton) {
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}

extension SettingVC: SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    /// Determine if the users device has In-App Purchases enabled,
    /// and if so, start the request for available purchases.  
    /// If IAP is not enabled, display message to user.
    func requestProductData() {
        if SKPaymentQueue.canMakePayments() {
            print("Success")
            let request = SKProductsRequest(productIdentifiers: self.productIdentifer)
            request.delegate = self
            request.start()
        } else {
            // Show Alert stating IAP are not enabled.
            let alert = UIAlertController(title: "In-App Purchases Not Enabled",
                                          message: "Please enable In App Purchases in Settings",
                                          preferredStyle: .alert)
            
            // Add Action 'Settings' to open settings
            alert.addAction(UIAlertAction(title: "Settings", style: .default, handler: { (alertAction) in
                alert.dismiss(animated: true, completion: nil)
                
                let url: URL? = URL(fileURLWithPath: UIApplicationOpenSettingsURLString)
                if url != nil {
                    UIApplication.shared.openURL(url!)
                }
            }))
            
            // Add Action 'OK' to dismiss alert
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (alertAction) in
                alert.dismiss(animated: true, completion: nil)
            }))
        }
    }
    
    
    /// SKProductsRequestDelegate Method
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        // Retrieve the response of products
        var products = response.products
        
        // Loop through and store each product in the
        // productsArray.
        if products.count != 0 {
            for i in 0 ..< products.count {
                self.product = products[i] as SKProduct
                self.productsArray.append(product!)
            }
        } else {
            print("No Products Found")
        }
        
        // Store any invalid product identifiers
        let prod = response.invalidProductIdentifiers
        
        // Print out the list of invalid identifiers
        for product in prod {
            print("\(product) was not found")
        }
    }

    /// Transaction of payment
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions as [SKPaymentTransaction] {
            switch transaction.transactionState {
            case .purchased:
                print("Transaction Approved")
                print("Product ID: \(transaction.payment.productIdentifier)")
                self.deliverProduct(transaction: transaction)
                SKPaymentQueue.default().finishTransaction(transaction)
            case .failed:
                print("Transaction Failed")
                SKPaymentQueue.default().finishTransaction(transaction)
            default:
                break
            }
        }
    }
    
    func deliverProduct(transaction: SKPaymentTransaction) {
        if transaction.payment.productIdentifier == "com.matthewcurtner.AdRemovalTest" {
            print("Non-Consumable Product Purchased")
            // Unlock Feature
        }
    }

    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        print("Transactions Restored")
        for transaction: SKPaymentTransaction in queue.transactions {
            if transaction.payment.productIdentifier == "com.matthewcurtner.AdRemovalTest" {
                print("Non-Consumable Product Purchased")
                // Unlock Feature
                
            }
        }
    }
}

