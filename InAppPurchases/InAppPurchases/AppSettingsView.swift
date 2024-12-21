//
//  AppSettingsView.swift
//  InAppPurchases
//
//  Created by Petar Sakotic on 10/21/24.
//

import SwiftUI
import StoreKit

struct AppSettingsView: View {
    @EnvironmentObject var storefront: PurchaseObservation
//    @Environment(PurchaseObservation.self) private var storefront: PurchaseObservation
    
    var body: some View {
        NavigationStack {
            ScrollView {
                
                switch storefront.hasHydratationPalPro {
                case true:
                    HydratationProMemberView()
                        .padding()
                case false:
                    MembershipView()
                        .padding()
                }

                TippingView()
                    .padding()
                AppInformationView()
                    .padding()
            }
            .navigationTitle("Settings")
        }
    }
}

struct HydratationProMemberView: View {
    @EnvironmentObject var storefront: PurchaseObservation
//    @Environment(PurchaseObservation.self) private var storefront: PurchaseObservation
    @State private var bounceCrown: Bool = false
    @State private var showJoinPro: Bool = false
    @State private var showManageSubs: Bool = false
    @State private var renewalInfo: String = ""
    
    var body: some View {
        VStack {
            Text("Membership")
                .font(.headline.weight(.bold))
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            
            VStack {
                HStack {
                    Text("You're on Pro")
                        .font(.title2.weight(.bold))
                    Spacer()
                    Image(systemName: "crown.fill")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(.blue)
                        .padding(12)
                        .background {
                            Circle()
                                .foregroundStyle(Color.black)
                        }
                        .symbolEffect(.bounce, value: bounceCrown)
                        .onAppear {
                            bounceCrown = true
                        }
                }
                
                Text("We're happy to have you. " + renewalInfo)
                    .fontWeight(.medium)
                    .foregroundStyle(Color.gray)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    .padding(.bottom)
                
                Button("Manage Subscription") {
                    showManageSubs.toggle()
                }
                .buttonBorderShape(.roundedRectangle(radius: 10))
                .buttonStyle(.bordered)
                .manageSubscriptionsSheet(isPresented: $showManageSubs)
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(Color.gray.opacity(0.2))
            }
        }
        .task {
            await fetchRenewsAtString()
        }
        
    }
    
    
    // MARK: Private Functions
    
    private func fetchRenewsAtString() async {
        guard let proAnnualSubscription = storefront.purchasedSubs.first,
              let status = try? await proAnnualSubscription.subscription?.status.first(where: { $0.state == .subscribed }) else {
            return
        }
        
        guard case .verified(let renewal) = status.renewalInfo,
              case .verified(let transaction) = status.transaction,
              renewal.willAutoRenew,
              let expirationDate = transaction.expirationDate else {
            return
        }
        
        renewalInfo = "Renews \(expirationDate.formatted(date: .abbreviated, time: .omitted))."
    }
}


struct MembershipView: View {
    
    @State private var showJoinPro: Bool = false
    @State private var bounceCrown: Bool = false
    
    var body: some View {
        VStack {
            Text("Membership")
                .font(.headline.weight(.bold))
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            
            VStack {
                HStack {
                    Text("Hydratation Pal Pro")
                        .font(.title.weight(.bold))
                    Spacer()
                    Image(systemName: "crown.fill")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(Color.blue)
                        .padding(12)
                        .background {
                            Circle()
                                .foregroundStyle(Color.black)
                        }
                        .symbolEffect(.bounce, value: bounceCrown)
                        .onAppear {
                            bounceCrown.toggle()
                        }
                }
                
                Text("Get the most out of Hydratation Pal. Join today and get these pro features:")
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical)
                ForEach(ProFeatures.allCases) { feature in
                    
                    HStack(alignment: .center) {
                        
                        Image(systemName: feature.symbol)
                            .resizable()
                            .scaledToFit()
                            .padding()
                            .frame(width: 58, height: 58)
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(Color.blue)
                        
                        VStack(alignment: .leading) {
                            
                            Text(feature.rawValue)
                                .font(.headline.weight(.medium))
                            Text(feature.description)
                                .font(.subheadline)
                                .foregroundStyle(Color.gray)
                            
                        }
                        
                        Spacer()
                    }
                    .padding(2)
                    .background {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(Color.white)
                    }
                }
                
                Button {
                    showJoinPro.toggle()
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
                        .padding(.top, 32)
                }
            }
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(Color.gray.opacity(0.2))
            }
        }
        .sheet(isPresented: $showJoinPro) {
            PaywallView()
        }
    }
}

struct TippingView: View {
    
    enum AvailableTips: String, Identifiable, CaseIterable, CustomStringConvertible {
        
        case small = "Small Tip"
        case medium = "Medium Tip"
        case large = "Large Tip"
        
        var id: Self { return self }
        
        var description: String {
            switch self {
            case .small: "Just a small little thank you. Always nice to get."
            case .medium: "Okay, that's awesome! Thanks so much!"
            case .large: "Blown away! You are the best."
            }
        }
        
        var emoji: String {
            switch self {
            case .small:
                "😀"
            case .medium:
                "😊"
            case .large:
                "🤯"
            }
        }
        
        var shortDescription: String {
            switch self {
            case .small:
                "small"
            case .medium:
                "medium"
            case .large:
                "large"
            }
        }
    }
    
    
    @State private var showError: Bool = false
    @State private var showSuccess: Bool = false
    @State private var tipAmount: String = ""
    
    @EnvironmentObject var storefront: PurchaseObservation
//    @Environment(PurchaseObservation.self) private var storefront: PurchaseObservation
    
    var body: some View {
        VStack {
            Text("Tips")
                .font(.headline.weight(.bold))
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
            
            ForEach(AvailableTips.allCases) { tip in
            
                HStack {
                    Text(tip.emoji)
                        .font(.title)
                        .foregroundStyle(Color.pink)
                        
                    VStack(alignment: .leading) {
                        Text(tip.rawValue)
                            .font(.headline)
                        
                        Text(tip.description)
                            .foregroundStyle(Color.gray)
                            .fontWeight(.medium)
                    }
                    
                    Spacer()
                    
                    Button {
                        buy(tip)
                    } label: {
                        Text(storefront.tips[tip]?.displayPrice ?? "")
                            .foregroundStyle(Color.white)
                            .buttonBorderShape(.capsule)
                            .buttonStyle(.borderedProminent)
                            .padding(10)
                            .background {
                                RoundedRectangle(cornerRadius: 14)
                                    .foregroundStyle(Color.blue)
                            }
                    }
                }
                .padding(10)
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(Color.gray.opacity(0.2))
                }
                
            }
        }
        .alert("Uh Oh!", isPresented: $showError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("We hit a problem, please try again.")
        }
        .alert("Thank you!", isPresented: $showSuccess) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("We'll put your tip for \(tipAmount) to good use ❤️.")
        }
    }
    
    
    
    private func buy(_ tip: AvailableTips) {
        Task {
            do {
                if try await storefront.purchase(tip) {
                    tipAmount = storefront.tips[tip]?.displayPrice ?? "0"
                    showSuccess.toggle()
                }
            } catch {
                showError.toggle()
            }
        }
    }
}


struct AppInformationView: View {
    
    private let version: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? ""
    
    
    var body: some View {
        VStack {
            Spacer()
            Text("In App Purchases")
                .font(.subheadline.weight(.semibold))
            Text("v\(version)")
                .fontWeight(.medium)
                .foregroundStyle(Color(uiColor: .secondaryLabel))
            Text("Enjoy your smoothie")
                .font(.caption2)
                .foregroundStyle(Color(uiColor: .secondaryLabel))
            Spacer()
        }
    }
}

#Preview {
    AppSettingsView()
        .environmentObject(PurchaseObservation())
}



