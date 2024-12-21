//
//  ViewRecipeView.swift
//  InAppPurchases
//
//  Created by Petar Sakotic on 10/18/24.
//

import SwiftUI

struct ViewRecipeView: View {
    
    let drink: SmoothieDrink
    @State private var recipe = AttributedString(stringLiteral: "")
    
    var body: some View {
        NavigationStack {
            Form {
                Text(recipe)
            }
            .navigationTitle("Smoothie")
        }
        .onAppear {
            let recipeText = SmoothieDrink.recipes()[drink] ?? ""
            
            if let markdownRecipe = markdownifyRecipe(recipeText) {
                recipe = markdownRecipe
            } else {
                recipe = AttributedString(stringLiteral: recipeText)
            }
            
        }
    }
    
    
    func markdownifyRecipe(_ text: String) -> AttributedString? {
        let recipeText = SmoothieDrink.recipes()[drink] ?? ""
        let options = AttributedString.MarkdownParsingOptions(allowsExtendedAttributes: false,
                                                              interpretedSyntax: .inlineOnlyPreservingWhitespace,
                                                              failurePolicy: .returnPartiallyParsedIfPossible,
                                                              languageCode: "en-US")
        if var attString = try? AttributedString(markdown: recipeText, options: options, baseURL: nil) {
            attString.font = .callout.weight(.medium)
            attString.foregroundColor = .init(uiColor: .secondaryLabel)
            
            
            return attString
        } else {
            return nil
        }
    }
}

#Preview {
    ViewRecipeView(drink: .avocadoDream)
}
