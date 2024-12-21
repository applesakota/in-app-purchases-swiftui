//
//  PaywallView.swift
//  InAppPurchases
//
//  Created by Petar Sakotic on 10/18/24.
//

import SwiftUI

struct PaywallView: View {
    
    @EnvironmentObject var storefront: PurchaseObservation
//    @Environment(PurchaseObservation.self) private var storefront: PurchaseObservation
    
    @State private var showWelcome: Bool = false
    @State private var showError: Bool = false
    
    var body: some View {
        ZStack {
            Color(uiColor: .systemBackground)
            ScrollView {
                switch showWelcome {
                case true:
                    WelcomeToProView()
                        .transition(.scale(0.8, anchor: .center)
                                    .combined(with: .opacity))
                    
                case false:
                    PaywallFeatureListingView {
                        joinPro()
                    } onRestorePurchases: {
                        restore()
                    }
                    .transition(.scale(0.8, anchor: .center)
                                .combined(with: .opacity))
                }
            }
            .scrollIndicators(.hidden)
            .padding(.horizontal, 32)
            .padding(.vertical)
            .alert("Ouch", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("We hit a problem, please try again.")
            }
            
        }
    }
    
    private func joinPro() {
        Task {
            do {
                if try await storefront.purchasePro() {
                    withAnimation {
                        showWelcome.toggle()
                    }
                }
            } catch {
                showError.toggle()
            }
        }
    }
    
    private func restore() {
        Task {
            do {
                try await storefront.restorePurchases()
                withAnimation {
                    showWelcome.toggle()
                }
                
            } catch {
                showError.toggle()
            }
        }
    }
}
struct PaywallFeatureListingView: View {
    
    @State private var showError: Bool = false
    
    let onJoinPro: () -> ()
    let onRestorePurchases: () -> ()
    
    var body: some View {
        VStack(spacing: 12) {
            Text("Join Hydratation Pro Today!")
                .font(.largeTitle.weight(.black))
            
            ForEach(ProFeatures.allCases) { feture in
                ExpandedFeatureView(feature: feture)
            }
            
            Button {
                onJoinPro()
            } label: {
                Text("Join Pro")
                    .font(.title2.weight(.bold))
                    .foregroundStyle(Color.white)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 8)
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(Color.blue)
                    }
            }
            
            Button {
                onRestorePurchases()
            } label: {
                Text("Restore Purchases")
                    .font(.headline.weight(.medium))
                    .foregroundStyle(Color.gray)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 8)
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(Color.gray.opacity(0.2))
                    }
            }
        }
    }
}

struct ExpandedFeatureView: View {
    let feature: ProFeatures
    @State private var bounce: Bool = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image(systemName: feature.symbol)
                .font(.largeTitle)
                .imageScale(.large)
                .foregroundStyle(Color.blue)
                .symbolEffect(.bounce.byLayer, value: bounce)
                .onAppear {
                    let randomVal = Double.random(in: 0...1.5)
                    DispatchQueue.main.asyncAfter(deadline: .now() + randomVal) {
                        bounce.toggle()
                    }
                }
            
            Text(feature.rawValue)
                .font(.title2.weight(.medium))
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            Text(feature.expandedDetails)
                .font(.subheadline.weight(.medium))
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
        }
        .padding(.bottom, 16)
    }
}


struct WelcomeToProView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 0) {
            Text("You're in!")
                .font(.largeTitle.weight(.black))
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 16)
            Text("Welcome to Hydratation Pro.")
                .font(.title.weight(.bold))
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 16)
            Text("You now have all pro features. Go make one of our custom smoothie drinks with our walkthrough guides, or go log some tea. We're happy to have you.")
                .foregroundStyle(Color(uiColor: .secondaryLabel))
                .font(.title2.weight(.semibold))
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                .padding(.bottom, 32)
            Button("Let's Go!") {
                presentationMode.wrappedValue.dismiss()
            }
            .font(.title3.weight(.semibold))
            .buttonBorderShape(.roundedRectangle(radius: 12.0))
            .buttonStyle(.borderedProminent)
        }
    }
}

#Preview {
    PaywallView()
        .environmentObject(PurchaseObservation())
}
