//
//  PurchaseOprations.swift
//  InAppPurchases
//
//  Created by Petar Sakotic on 10/21/24.
//

import Foundation
import Observation
import StoreKit

@MainActor
class PurchaseObservation: ObservableObject {
    
    // Available Products
    @Published private(set) var tips: [TippingView.AvailableTips: Product] = [:]
    @Published private(set) var recipes: [SmoothieDrink: Product] = [:]
    @Published private(set) var subs: [Product] = []
    
    @Published private(set) var purchasedRecipies: [SmoothieDrink] = []
    @Published private(set) var purchasedSubs: [Product] = []
    @Published private(set) var hasHydratationPalPro: Bool = false
    
    // Listen for transactions
    var transactionListener: Task<Void, Error>? = nil
    
    init() {
        Task {
            await configure()
        }
    }
    
    deinit {
        transactionListener?.cancel()
    }
    
    func configure() async  {
        do {
            transactionListener = createTransactionTask()
            try await AppStore.sync()
            try await retriveAllProducts()
            try await updateUserPurchases()
        } catch {
            print("error")
        }
    }
    
    func retriveAllProducts() async throws {
        do {
            let tipIdentifiers: [String] = PurchaseObservation.tipProductIdentifiers
            let recipeIdentifiers: [String] = PurchaseObservation.recipeProductIdentifiers
            let subIdentifiers: [String] = ["subscription.hydratationPalPro.annual"]
            let allIdentifiers: [String] = tipIdentifiers + recipeIdentifiers + subIdentifiers
            
            let products = try await Product.products(for: allIdentifiers)
            let allTips = TippingView.AvailableTips.allCases
            let allRecipes = SmoothieDrink.allSmoothies()
            
            for product in products {
                switch product.type {
                case .consumable:
                    
                    if let tip = allTips.first(where: {$0.skIdentifier == product.id }) {
                        self.tips[tip] = product
                    } else {
                        print("Unknown product id: \(product.id)")
                    }
                    
                case .nonConsumable:
                    
                    if let recipe = allRecipes.first(where: {$0.skIdentifier == product.id}) {
                        self.recipes[recipe] = product
                    } else {
                        print("Unknown product id: \(product.id)")
                    }
                    
                case .autoRenewable:
                    self.subs.append(product)
                    
                default:
                    print("Unknown product with identifier \(product.id)")
                }
            }
            
        } catch {
            print(error)
            throw error
        }
    }
    
    
    func hasPurchased(_ recipe: SmoothieDrink) -> Bool {
        if hasHydratationPalPro {
            return true
        }
        
        return purchasedRecipies.contains(recipe)
    }
    
    
    func purchase(_ tip: TippingView.AvailableTips) async throws -> Bool {
        guard let product = self.tips[tip] else {
            throw InAppPurchasesError.productNotFound
        }
        
        return try await purchaseProduct(product)
    }
    
    
    func purchase(_ recipe: SmoothieDrink) async throws -> Bool {
        guard let product = self.recipes[recipe] else {
            throw InAppPurchasesError.productNotFound
        }
        
        return try await purchaseProduct(product)
    }
    
    func purchasePro() async throws -> Bool {
        guard let product = subs.first else {
            throw InAppPurchasesError.productNotFound
        }
        
        return try await purchaseProduct(product)
    }
    
    func restorePurchases() async throws {
        do {
            try await AppStore.sync()
            try await updateUserPurchases()
        } catch {
            throw error
        }
    }
    
    private func purchaseProduct(_ product: Product) async throws -> Bool {
        
        do {
            let result = try await product.purchase()
            switch result {
            case .success(let result):
                let verificationResult = try self.verifyPurchase(result)
                try await updateUserPurchases()
                await verificationResult.finish()
                
                return true
                
            case .userCancelled: print("Cancelled")
            case .pending: print("Needs Approval")
            @unknown default: fatalError()
            }
            return false
            
        } catch {
            throw error
        }
        
    }
    
    private func verifyPurchase<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw InAppPurchasesError.failedVerification
        case .verified(let safe):
            return safe
        }
    }
    

    private func updateUserPurchases() async throws {
        let allRecipes = SmoothieDrink.allSmoothies()
        
        for await entitlement in Transaction.currentEntitlements {
            do {
                let verifiedPurchase = try verifyPurchase(entitlement)
                
                switch verifiedPurchase.productType {
                case .nonConsumable:
                    
                    if let recipe = allRecipes.first(where: { $0.skIdentifier == verifiedPurchase.productID }) {
                        purchasedRecipies.append(recipe)
                    } else {
                        print("Verified purchase couldn't be matched to local model.")
                    }
                    
                case .autoRenewable:
                    
                    if let subscription = subs.first(where: { $0.id == verifiedPurchase.productID }) {
                        // Add a check here to ensure the subscription is still active
                        if let expirationDate = verifiedPurchase.expirationDate, expirationDate > Date() {
                            purchasedSubs.append(subscription)
                            self.hasHydratationPalPro = true // Mark user as Hydration Pro only if it's active
                        } else {
                            self.hasHydratationPalPro = false // Set it to false if the subscription has expired
                        }
                    } else {
                        print("Verified subscription cound't be matched to fetched subscription.")
                    }
                    
                default:
                    break
                    
                }
                
            } catch {
                print("Failing silently: Possible unverified purchase.")
                throw error
            }
        }
        
    }
    
    private func createTransactionTask() -> Task<Void, Error> {
        return Task.detached {
            for await update in Transaction.updates {
                do {
                    let transaction = try await self.verifyPurchase(update)
                    // Check for expired or revoked transactions before proceeding
                    if let expirationDate = transaction.expirationDate, expirationDate > Date() {
                        try await self.updateUserPurchases()
                    }
                    
                    await transaction.finish()
                } catch {
                    print("Transaction didn't pass verification - ignoring purchase.")
                }
            }
        }
    }
}

extension PurchaseObservation {
    static var tipProductIdentifiers: [String] {
        get {
            return TippingView.AvailableTips.allCases.map{ $0.skIdentifier }
        }
    }
    
    static var recipeProductIdentifiers: [String] {
        get {
            return SmoothieDrink.allSmoothies().map { $0.skIdentifier }
        }
    }
}

extension SmoothieDrink {
    var skIdentifier: String {
        return "nonconsumable.recipe." + id
    }
}


extension TippingView.AvailableTips {
    var skIdentifier: String {
        return "consumable.tip." + self.shortDescription
    }
}


enum InAppPurchasesError: Error {
    case productNotFound, failedVerification
}
