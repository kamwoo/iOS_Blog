//
//  APIManager.swift
//  iOS_Blog
//
//  Created by wooyeong kam on 2021/11/10.
//

import Foundation
import Purchases
import StoreKit

class IAPManager {
    static let shared = IAPManager()
    
    private init() {}
    
    private var postEligibleViewDate: Date?
    
    func isPremium() -> Bool {
        return true
    }
    
    func getSubscriptionStatus(completion:((Bool) -> Void)?){
        Purchases.shared.purchaserInfo{ info, error in
            guard let entitlement = info?.entitlements,
                  error == nil else {
                return
            }
            
            if entitlement.all["Premium"]?.isActive == true {
                UserDefaults.standard.setValue(true, forKey: "premium")
                completion?(true)
            }
            else{
                UserDefaults.standard.setValue(false, forKey: "premium")
                completion?(false)
            }
        }
    }
    
    func fetchPackages(completion: @escaping (Purchases.Package?) -> Void){
        Purchases.shared.offerings{ offering, error in
            guard let package = offering?.offering(identifier: "default")?.availablePackages.first,
                  error == nil else{
                completion(nil)
                return
            }
            completion(package)
        }
    }
    
    func subscribe(package: Purchases.Package){
        Purchases.shared.purchasePackage(package){ transaction, info, error, userCanceled in
            guard let transaction = transaction,
                  let entitlements = info?.entitlements,
                  error == nil,
                  !userCanceled else{
                return
            }
            
            switch transaction.transactionState {
            case .purchasing:
                print("purchasing")
            case .purchased:
                print("purchased")
                UserDefaults.standard.setValue(true, forKey: "premium")
            case .failed:
                print("failed")
            case .restored:
                print("restored")
            case .deferred:
                print("deferred")
            @unknown default:
                print("defualt")
            }
        }
    }
    
    func restorePurchases(){
        Purchases.shared.restoreTransactions{ info, error in
            guard let entitlement = info,
                  error == nil else {
                return
            }
            print(entitlement)
        }
    }
}

extension IAPManager{
    var canViewPost:Bool{
        guard let date = postEligibleViewDate else {
            return true
        }
        UserDefaults.standard.setValue(0, forKey: "post_views")
        return Date() >= date
    }
    
    func logPostViewed(){
        let total = UserDefaults.standard.integer(forKey: "post_views")
        UserDefaults.standard.setValue(total+1, forKey: "post_views")
        
        if total == 3{
            let hour : TimeInterval = 60*60
            postEligibleViewDate = Date().addingTimeInterval(hour*24)
        }
    }
}
