//
//  PurchaseViewController.swift
//  TikTokBusinessSDKTestApp
//
//  Created by Aditya Khandelwal on 10/7/20.
//  Copyright © 2020 bytedance. All rights reserved.
//

import UIKit
import StoreKit

class PurchaseViewController: UIViewController, SKPaymentTransactionObserver {
    
    let consumableProductId = "btd.TikTokBusinessSDKTestApp.ConsumablePurchaseOne";
    let nonConsumableProductId = "btd.TikTokBusinessSDKTestApp.NonConsumablePurchaseOne";
    let ARSubscriptionProductId = "btd.TikTokBusinessSDKTestApp.ARSubscriptionPurchaseOne";
    let NRSubscriptionProductId = "btd.TikTokBusinessSDKTestApp.NRSubscriptionPurchaseOne";
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
        for transaction in transactions {
            if transaction.transactionState == .purchased {
                print("Transaction successful!")
//                print(transaction.payment.productIdentifier)
                queue.finishTransaction(transaction);
            } else if transaction.transactionState == .failed {
                print("Transaction failed!")
            } else if transaction.transactionState == .restored {
                print(transaction.transactionIdentifier as Any)
                print("Transaction restored")
            }
            if transaction.transactionState != .purchasing {
                queue.finishTransaction(transaction);
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Purchase"
        
        SKPaymentQueue.default().add(self)
        // Do any additional setup after loading the view.
    }
    

    @IBAction func purchaseConsumable(_ sender: Any) {
        print("Consumable Purchased!")
        
        if SKPaymentQueue.canMakePayments() {
            let paymentRequest = SKMutablePayment()
            paymentRequest.productIdentifier = consumableProductId
            SKPaymentQueue.default().add(paymentRequest)
        } else {
            print("User unable to make payments!")
        }
        
    }
    @IBAction func purchaseNonConsumable(_ sender: Any) {
        print("Non-Consumable Purchased!")
        
        if SKPaymentQueue.canMakePayments() {
            let paymentRequest = SKMutablePayment()
            paymentRequest.productIdentifier = nonConsumableProductId
            SKPaymentQueue.default().add(paymentRequest)
        } else {
            print("User unable to make payments!")
        }
    }
    @IBAction func purchaseARSubscription(_ sender: Any) {
        print("Auto-Renewable Subscription Purchased!")
        
        if SKPaymentQueue.canMakePayments() {
            let paymentRequest = SKMutablePayment()
            paymentRequest.productIdentifier = ARSubscriptionProductId
            SKPaymentQueue.default().add(paymentRequest)
        } else {
            print("User unable to make payments!")
        }
    }
    @IBAction func purchaseNRSubscription(_ sender: Any) {
        print("Non-Renewable Subscription Purchased!")
        
        if SKPaymentQueue.canMakePayments() {
            let paymentRequest = SKMutablePayment()
            paymentRequest.productIdentifier = NRSubscriptionProductId
            SKPaymentQueue.default().add(paymentRequest)
        } else {
            print("User unable to make payments!")
        }
    }
    @IBAction func restoreAllPurchases(_ sender: Any) {
        print("Restored All Purchase!")
        if SKPaymentQueue.canMakePayments() {
            SKPaymentQueue.default().restoreCompletedTransactions();
        }
    }
}
