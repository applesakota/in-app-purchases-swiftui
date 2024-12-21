//
//  IntakeView.swift
//  InAppPurchases
//
//  Created by Petar Sakotic on 10/17/24.
//

import SwiftUI

struct IntakeView: View {
    @EnvironmentObject var storefront: PurchaseObservation
//    @Environment(PurchaseObservation.self) private var storefront: PurchaseObservation
    
    var body: some View {
        NavigationStack {
            ScrollView {
                WaterGaugeView()
                    .padding(.bottom, 32)
                    .padding(.top, 32)
                
                QuickLogView()
                    .padding()
            }
            .navigationTitle("Current Hydratation")
        }
    }
    
}


struct WaterGaugeView: View {
    
    
    var body: some View {
        Text("0.0")
            .font(.system(size: 54))
            .foregroundStyle(.white)
            .fontWeight(.bold)
            .frame(width: 200)
            .minimumScaleFactor(0.8)
            .padding(64)
            .background {
                Circle()
                    .foregroundStyle(Color(uiColor: .blue))
                    .opacity(0.35)
            }
            .padding()
            .background {
                CircularProgressView(progress: 0.0)
            }
    }
    
}

struct CircularProgressView: View {
    
    var progress: CGFloat
    var backgroundColor: Color = .blue
    private let lineWidth: Double = 20.0
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: lineWidth)
                .foregroundStyle(backgroundColor.opacity(0.5))
                .opacity(0.6)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(style: StrokeStyle(lineWidth: lineWidth,
                                           lineCap: .round))
                .foregroundColor(.blue)
                .rotationEffect(.degrees(-90))
                .animation(.spring, value: progress)
        }
    }
}

struct QuickLogView: View {
    
    var body: some View {
        GroupBox("Quick Log") {
            QuickAddButton(text: "Water", amountToLog: 64)
            Divider()
            QuickAddButton(text: "Smoothie", amountToLog: 128)
            Divider()
            QuickAddButton(text: "Tea", amountToLog: 192)
        }
    }
}

struct QuickAddButton: View {
    @EnvironmentObject var storefront: PurchaseObservation
//    @Environment(PurchaseObservation.self) private var storefront: PurchaseObservation
    
    @State var showPaywall: Bool = false
    let text: String
    let amountToLog: Double
    
    
    var body: some View {
        HStack {
            Text(text)
                .fontWeight(.medium)
            Spacer()
            Button("Log") {
                if storefront.hasHydratationPalPro {
                    print("LOg")
                } else {
                    showPaywall.toggle()
                }
            }
            .fontWeight(.bold)
            .buttonBorderShape(.capsule)
            .buttonStyle(.borderedProminent)
        }
        .padding(.vertical, 6)
        .sheet(isPresented: $showPaywall) {
            PaywallView()
        }
    }
}

#Preview {
    IntakeView()
        .environmentObject(PurchaseObservation())
}
