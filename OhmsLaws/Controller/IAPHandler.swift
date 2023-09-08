//
//  IAPHandler.swift
//  OhmsLaws
//
//  Created by Matthew Curtner on 8/15/18.
//  Copyright © 2018 Matthew Curtner. All rights reserved.
//

import UIKit
import StoreKit

enum IAPHandlerAlertType {
    case disabled
    case restored
    case purchased
    
    func message() -> String {
        switch self {
        case .disabled:
            return "Purchases are disabled in your device!"
        case .restored:
            return "You have successfully restored your purchase!"
        case.purchased:
            return "You have successfully bought this purchase!"
        }
    }
}
    
class IAPHandler: NSObject {
    
    static let shared = IAPHandler()
    let NON_CONSUMABLE_PURCHASE_PRODUCT_ID = "com.matthewcurtner.AdRemovalTest"
    
    fileprivate var productID = ""
    fileprivate var productsRequest = SKProductsRequest()
    fileprivate var iapProducts = [SKProduct]()
    
    var purchaseStatusBlock: ((IAPHandlerAlertType) -> Void)?
    
    // MARK: - Make a purchase
    func canMakePurchases() -> Bool {
        return SKPaymentQueue.canMakePayments()
    }
    
    func purchaseProduct(index: Int) {
        if iapProducts.count == 0 {
            return
        }
        
        if self.canMakePurchases() {
            let product = iapProducts[index]
            let payment = SKPayment(product: product)
            SKPaymentQueue.default().add(self)
            SKPaymentQueue.default().add(payment)
            
            print("Product to purchase: \(product.productIdentifier)")
            productID = product.productIdentifier
        } else {
            purchaseStatusBlock?(.disabled)
        }
    }
    
    // MARK: - Restore a purchase
    func restorePurchase() {
        SKPaymentQueue.default().add(self)
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    func fetchAvailableProducts() {
        let productIdentifiers = NSSet(objects: NON_CONSUMABLE_PURCHASE_PRODUCT_ID)
        
        productsRequest = SKProductsRequest(productIdentifiers: productIdentifiers as! Set<String>)
        productsRequest.delegate = self
        productsRequest.start()
    }
}


extension IAPHandler: SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    // MARK: - InApp Purchase Products
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if response.products.count > 0 {
            iapProducts = response.products
            
            for product in iapProducts {
                let numberFormatter = NumberFormatter()
                numberFormatter.formatterBehavior = .behavior10_4
                numberFormatter.numberStyle = .currency
                numberFormatter.locale = product.priceLocale
                
                let priceStr = numberFormatter.string(from: product.price)
                print(product.localizedDescription + "for just \(priceStr!)")
            }
        }
    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        purchaseStatusBlock?(.restored)
    }
    
    // MARK: - InApp Purchase Queue
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction: AnyObject in transactions {
            if let trans = transaction as? SKPaymentTransaction {
                switch trans.transactionState {
                case .purchased:
                    print("purchased")
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    purchaseStatusBlock?(.purchased)
                    SettingsController.shared.setShowAdsValue(showAds: false)
                    break
                case .failed:
                    print("Failed")
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    if SettingsController.shared.readDefaultForAds() == true {
                        
                    } else {
                        SettingsController.shared.setShowAdsValue(showAds: false)
                    }
                    
                    break
                case .restored:
                    print("restored")
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    SettingsController.shared.setShowAdsValue(showAds: false)
                    break
                default:
                    break
                }
            }
        }
    }
}
