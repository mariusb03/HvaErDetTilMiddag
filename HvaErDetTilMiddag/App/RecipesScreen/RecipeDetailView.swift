//
//  RecipeDetailView.swift
//  HvaErDetTilMiddag
//
//  Created by Marius Bringsvor Rusten on 05/05/2025.
//

import SwiftUI

struct RecipeDetailView: View {
    @Binding var recipe: Recipe
    var onDelete: () -> Void

    @EnvironmentObject var inventoryModel: InventoryModel
    @EnvironmentObject var shoppingModel: ShoppingModel
    @Environment(\.presentationMode) var presentationMode

    @State private var showEditPopup = false

    var body: some View {
        ZStack {
            backgroundGradient

            ScrollView {
                content
            }

            if showEditPopup {
                editPopupOverlay
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Subviews

    private var backgroundGradient: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color("LightGreen"), Color("Background")]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }

    private var content: some View {
        VStack(alignment: .leading, spacing: 24) {
            titleSection
            actionButtons
            ingredientsSection
            instructionsSection
            addMissingToShoppingListButton
            Spacer(minLength: 40)
        }
        .padding(24)
    }
    
    private var addMissingToShoppingListButton: some View {
        Button(action: {
            shoppingModel.addMissing(from: recipe, inventory: inventoryModel.ingredients)
        }) {
            HStack {
                Image(systemName: "cart.badge.plus")
                Text("Legg til manglende i handleliste")
            }
            .font(.subheadline)
            .fontDesign(.rounded)
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color("PrimaryGreen"))
            .cornerRadius(12)
        }
        .padding(.horizontal)
    }

    private var titleSection: some View {
        HStack {
            Spacer()
            Text(recipe.title)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color("PrimaryGreen"))
                .fontDesign(.rounded)
                .padding(.top)
            Spacer()
        }
    }

    private var actionButtons: some View {
        HStack(spacing: 20) {
            Spacer()

            Button {
                withAnimation(.spring()) {
                    showEditPopup = true
                }
            } label: {
                Label("Rediger", systemImage: "pencil")
                    .foregroundColor(Color("PrimaryGreen"))
                    .font(.caption)
            }

            Button {
                onDelete()
                presentationMode.wrappedValue.dismiss()
            } label: {
                Label("Slett", systemImage: "trash")
                    .foregroundColor(.red)
                    .font(.caption)
            }

            Spacer()
        }
    }

    private var ingredientsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Ingredienser")
                .font(.headline)
                .foregroundColor(Color("DeepGreen"))
                .fontDesign(.rounded)

            ForEach(recipe.ingredients) { ingredient in
                let isAvailable = inventoryModel.ingredients.contains {
                    $0.name.lowercased() == ingredient.name.lowercased() &&
                    $0.unit.lowercased() == ingredient.unit.lowercased() &&
                    (Double($0.quantity) ?? 0) >= (Double(ingredient.quantity) ?? 0)
                }

                HStack(spacing: 6) {
                    Image(systemName: isAvailable ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .foregroundColor(isAvailable ? Color("PrimaryGreen") : .red)
                        .imageScale(.small)

                    Text("\(ingredient.name) – \(ingredient.quantity) \(ingredient.unit)")
                        .font(.subheadline)
                        .foregroundColor(isAvailable ? Color("PrimaryGreen") : .red)
                        .fontDesign(.rounded)

                    if !isAvailable {
                        Text("(mangler)")
                            .font(.caption)
                            .foregroundColor(.red)
                            .fontDesign(.rounded)
                    }
                }
            }
        }
    }

    private var instructionsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Fremgangsmåte")
                .font(.headline)
                .foregroundColor(Color("DeepGreen"))
                .fontDesign(.rounded)

            Text(recipe.instructions)
                .font(.body)
                .foregroundColor(Color("PrimaryGreen"))
                .fontDesign(.rounded)
                .multilineTextAlignment(.leading)
        }
    }

    private var editPopupOverlay: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation(.easeOut(duration: 0.25)) {
                        showEditPopup = false
                    }
                }

            AddRecipePopupView(
                initialRecipe: recipe,
                onClose: {
                    withAnimation(.easeOut(duration: 0.25)) {
                        showEditPopup = false
                    }
                },
                onSave: { updated in
                    recipe = updated
                    withAnimation {
                        showEditPopup = false
                    }
                }
            )
            .transition(.scale.combined(with: .opacity))
        }
    }
}
