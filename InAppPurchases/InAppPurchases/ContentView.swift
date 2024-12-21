//
//  ContentView.swift
//  InAppPurchases
//
//  Created by Petar Sakotic on 10/17/24.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        TabView {
            IntakeView()
                .tabItem {
                    TabIconView(symbolName: "chart.line.uptrend.xyaxis", text: "Intake")
                }
            
            RecipesView()
                .tabItem {
                    TabIconView(symbolName: "leaf", text: "Smoothie")
                }
            
            AppSettingsView()
                .tabItem {
                    TabIconView(symbolName: "gear", text: "Settings")
                }
            
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(PurchaseObservation())
}
