//
//  ShoppingListView.swift
//  HvaErDetTilMiddag
//
//  Created by Marius Bringsvor Rusten on 22/04/2025.
//

import SwiftUI

struct ShoppingListView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("🍳 Shopping List")
                    .font(.largeTitle)
                    .padding()

                Text("Here you'll see The shoppinglist.")
                    .padding()
                    .foregroundColor(.gray)
            }
        }
    }
}
