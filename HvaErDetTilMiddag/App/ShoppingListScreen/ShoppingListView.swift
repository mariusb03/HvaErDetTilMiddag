//
//  ShoppingListView.swift
//  HvaErDetTilMiddag
//
//  Created by Marius Bringsvor Rusten on 22/04/2025.
//

import SwiftUI

struct ShoppingListView: View {
    @EnvironmentObject var shoppingModel: ShoppingModel
    @EnvironmentObject var inventoryModel: InventoryModel

    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 16) {
                Text("🛒 Handleliste")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(Color("PrimaryGreen"))
                    .padding(.top)
                    .padding(.horizontal)
                    .fontDesign(.rounded)

                if shoppingModel.items.isEmpty {
                    VStack(spacing: 12) {
                        Spacer()
                        Image(systemName: "checkmark.circle")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .foregroundColor(Color("PrimaryGreen"))
                        Text("Du har alt du trenger!")
                            .font(.headline)
                            .foregroundColor(.gray)
                            .fontDesign(.rounded)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                } else {
                    List {
                        ForEach(shoppingModel.items) { ingredient in
                            HStack {
                                Image(systemName: "circle")
                                    .foregroundColor(.gray)

                                VStack(alignment: .leading) {
                                    Text(ingredient.name.capitalized)
                                        .font(.body)
                                    Text("\(ingredient.quantity) \(ingredient.unit)")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }

                                Spacer()

                                Button {
                                    withAnimation {
                                        shoppingModel.markAsBought(ingredient, inventoryModel: inventoryModel)
                                    }
                                } label: {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(Color("PrimaryGreen"))
                                }
                            }
                            .padding(.vertical, 4)
                            .fontDesign(.rounded)
                        }
                        .onDelete { indexSet in
                            shoppingModel.items.remove(atOffsets: indexSet)
                        }
                    }
                    .listStyle(.insetGrouped)
                }

                Spacer()
            }
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color("LightGreen"), Color("Background")]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                ).ignoresSafeArea()
            )
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
