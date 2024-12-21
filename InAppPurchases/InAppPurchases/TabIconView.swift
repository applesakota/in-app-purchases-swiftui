//
//  TabIconView.swift
//  InAppPurchases
//
//  Created by Petar Sakotic on 10/21/24.
//

import SwiftUI

struct TabIconView: View {
    let symbolName: String
    let text: String
    
    var body: some View {
        HStack {
            Image(systemName: symbolName)
            Text(text)
        }
    }
}

#Preview {
    TabIconView(symbolName: "rays", text: "Rays")
}
