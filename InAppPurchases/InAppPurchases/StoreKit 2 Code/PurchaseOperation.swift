//
//  PurchaseOperation.swift
//  InAppPurchases
//
//  Created by Petar Sakotic on 10/21/24.
//

import Foundation


enum ProFeatures: String, Identifiable, CaseIterable, CustomStringConvertible {
    
    case logging = "Water logging"
    case smoothieRecipes = "Smoothie Recipes"
    
    //MARK: - Identifiable
    var id: Self { return self }
    
    var description: String {
        
        switch self {
        case .logging: "Easily log your smoothie drinks."
        case .smoothieRecipes: "Smoothie Recipes"
        
        }
    }
    
    var expandedDetails: String {
        switch self {
        case .logging: "Our quick and easy smoothie logging feature lets you record your favorite smoothie purchases in just a few taps. Track your go-to blends and stay on top of your smoothie game effortlessly!"
        case .smoothieRecipes: "Unlock access to the world’s most exclusive smoothie recipes. Create our signature drinks right at home with ease and enjoy premium blends in every sip!"
        }
    }
    
    var symbol: String {
        switch self {
        case .logging: "checklist.checked"
        case .smoothieRecipes: "book.pages.fill"
        }
    }
    
}
