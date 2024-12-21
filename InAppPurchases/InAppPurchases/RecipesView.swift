//
//  RecipesView.swift
//  InAppPurchases
//
//  Created by Petar Sakotic on 10/17/24.
//

import SwiftUI
import TipKit

struct RecipesView: View {
    
    fileprivate enum ModalOption: Identifiable {
        case recipe(SmoothieDrink)
        case paywall
        
        var id: String {
            switch self {
            case .recipe(let smoothieDrink):
                return smoothieDrink.id
            case .paywall:
                return "paywall"
            }
        }
    }
    
    @EnvironmentObject var storefront: PurchaseObservation
//    @Environment(PurchaseObservation.self) private var storefront: PurchaseObservation
    
    @State private var tip: RecipeTip? = RecipeTip(price: "0.99")
    @State private var modalSelection: ModalOption? = nil
    @State private var showError: Bool = false
    @State private var showSuccess: Bool = false
    @State private var purchasedRecipe: SmoothieDrink = .empty
    
    var body: some View {
        NavigationStack {
            ScrollView {
                
                if let purchaseTip = tip {
                    TipView(purchaseTip, arrowEdge: .bottom)
                        .padding(.horizontal)
                }
                
                Text("This Week's Specials")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)
                    .padding(.top)
                
                FeaturedSmoothieDrinksView { smoothie in
                    handleSelectionFor(smoothie)
                }
                .padding(.vertical)
                
                Text("Smoothies")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)
                    .padding(.top)
                
                GroupBox {
                    ForEach(SmoothieDrink.allSmoothies()) { smoothie in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(smoothie.name)
                                    .font(.headline)
                                    .padding(.bottom, 4)
                                Text(smoothie.description)
                                    .font(.subheadline.weight(.medium))
                                    .foregroundStyle(Color.gray)
                            }
                            
                            Spacer()
                            
                            Button(storefront.hasPurchased(smoothie) ? "View" : "Buy") {
                                handleSelectionFor(smoothie)
                            }
                            .foregroundStyle(Color.white)
                            .buttonBorderShape(.capsule)
                            .buttonStyle(.borderedProminent)
                            .padding(.leading, 8)                    
                        }
                        .padding(.vertical)
                        Divider()
                    }
                }
                
                .padding(.horizontal)
                .padding(.top)
            }
            .navigationTitle("Smoothie Menu")
            .sheet(item: $modalSelection) { selection in
                switch selection {
                case .recipe(let smoothieDrink):
                    ViewRecipeView(drink: smoothieDrink)
                case .paywall:
                    PaywallView()
                }
            }
            .alert("Uh Oh!", isPresented: $showError) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("We hit a problem, please try again.")
            }
            .alert("New Recipe Added", isPresented: $showSuccess) {
                Button("OK", role: .cancel) { }
            } message: {
                Text("Now you can make \(purchasedRecipe.name) anytime.")
            }
        }
        .onAppear {
            setTipPriceString()
        }
    }
    
    private func setTipPriceString() {
        if let firstRecipeProduct = storefront.recipes.values.first {
            self.tip = .init(price: firstRecipeProduct.displayPrice)
        }
    }
    
    private func handleSelectionFor(_ recipe: SmoothieDrink) {
        
        guard storefront.hasHydratationPalPro || storefront.hasPurchased(recipe) else {
            buy(drink: recipe)
            return
        }
        
        modalSelection = .recipe(recipe)
    }
    
    private func buy(drink: SmoothieDrink) {
        Task {
            do {
                if try await storefront.purchase(drink) {
                    purchasedRecipe = drink
                    showSuccess.toggle()
                }
            } catch {
                showError.toggle()
            }
        }
    }
}

struct RecipeTip: Tip {
    private var price: String
    
    init(price: String) {
        try? Tips.resetDatastore()
        try? Tips.configure([
            .displayFrequency(.immediate),
            .datastoreLocation(.applicationDefault)
        ])
        self.price = price
    }
    
    var title: Text {
        Text("Our Signature Recipes")
    }
    
    var message: Text? {
        Text("Make smoothie drinks like never before. Each of our secret smoothie recipes are available for purchase for \(price).")
    }
    
    var image: Image? {
        Image(systemName: "takeoutbag.and.cup.and.straw.fill")
    }
    
}

struct FeaturedSmoothieDrinksView: View {
    
    private let featured: [SmoothieDrink] = [.strawberryBanana, .berryBlast, .coconutParadise]
    let actionOnTap: (SmoothieDrink) -> ()
    
    @EnvironmentObject var storefront: PurchaseObservation
//    @Environment(PurchaseObservation.self) private var storefront: PurchaseObservation
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 10) {
                
                ForEach(featured) { smoothie in
                    Image(smoothie.imageFile())
                        .resizable()
                        .aspectRatio(3.0 / 2.0, contentMode: .fit)
                        .containerRelativeFrame(.horizontal, count: 1, spacing: 0)
                        .overlay(alignment: .bottom) {
                            HStack {
                                Text(smoothie.name)
                                    .fontWeight(.medium)
                                    .padding(.leading, 4)
                                Spacer()
                                
                                Button {
                                    actionOnTap(smoothie)
                                } label: {
                                    Text(storefront.hasPurchased(smoothie) ? "View" : "Buy")
                                }
                                .foregroundStyle(Color.white)
                                .buttonBorderShape(.capsule)
                                .buttonStyle(.borderedProminent)
                                .padding(.trailing, 4)
                            }
                            .padding(8)
                            .background {
                                Rectangle()
                                    .foregroundStyle(Material.thin)
                            }
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 10.0))
                    
                }
            }
        }
        .scrollTargetBehavior(.paging)
        .safeAreaPadding(.horizontal, 16)
        .scrollIndicators(.hidden)
    }
}


#Preview {
    RecipesView()
        .environmentObject(PurchaseObservation())
}
