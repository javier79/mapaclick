//
//  StoreManager.swift
//  mapaclick
//
//  Created by javier pizarro on 2/17/26.
//

import StoreKit

class StoreManager: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
    
    static let shared = StoreManager()
    
    let removeAdsProductID = "com.javierpizarro.mapaclick.removeads"
    
    private var product: SKProduct?
    
    // Callback for UI updates
    var onPurchaseComplete: (() -> Void)?
    var onPurchaseFailed: ((String) -> Void)?
    
    private override init() {
        super.init()
        SKPaymentQueue.default().add(self)
    }
    
    // MARK: - Fetch Product
    
    func fetchProduct() {
        let request = SKProductsRequest(productIdentifiers: [removeAdsProductID])
        request.delegate = self
        request.start()
    }
    
    // MARK: - Purchase
    
    func purchaseRemoveAds() {
        guard let product = product else {
            onPurchaseFailed?("Product not available. Please try again later.")
            return
        }
        
        guard SKPaymentQueue.canMakePayments() else {
            onPurchaseFailed?("Purchases are disabled on this device.")
            return
        }
        
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    // MARK: - Restore
    
    func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    // MARK: - Check if already purchased
    
    static func isAdRemovalPurchased() -> Bool {
        return UserDefaults.standard.bool(forKey: "removeAdsPurchased")
    }
    
    private static func markAdRemovalPurchased() {
        UserDefaults.standard.set(true, forKey: "removeAdsPurchased")
        AdManager.shared.adsEnabled = false
        AdManager.shared.removeBanner()
    }
    
    // MARK: - SKProductsRequestDelegate
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if let fetchedProduct = response.products.first {
            product = fetchedProduct
            print("Product fetched: \(fetchedProduct.localizedTitle) - \(fetchedProduct.price)")
        } else {
            print("No products found")
        }
    }
    
    // MARK: - SKPaymentTransactionObserver
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                StoreManager.markAdRemovalPurchased()
                SKPaymentQueue.default().finishTransaction(transaction)
                onPurchaseComplete?()
                print("Purchase successful")
                
            case .restored:
                StoreManager.markAdRemovalPurchased()
                SKPaymentQueue.default().finishTransaction(transaction)
                onPurchaseComplete?()
                print("Purchase restored")
                
            case .failed:
                SKPaymentQueue.default().finishTransaction(transaction)
                if let error = transaction.error as? SKError, error.code != .paymentCancelled {
                    onPurchaseFailed?(error.localizedDescription)
                }
                print("Purchase failed")
                
            case .deferred, .purchasing:
                break
                
            @unknown default:
                break
            }
        }
    }
}
