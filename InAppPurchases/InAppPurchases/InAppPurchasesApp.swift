//
//  InAppPurchasesApp.swift
//  InAppPurchases
//
//  Created by Petar Sakotic on 10/17/24.
//

import SwiftUI

@main
struct InAppPurchasesApp: App {
    
    @StateObject private var purchases: PurchaseObservation = PurchaseObservation()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(purchases)
        }
    }
}
