//
//  RecipesView.swift
//  HvaErDetTilMiddag
//
//  Created by Marius Bringsvor Rusten on 05/05/2025.
//

import SwiftUI

struct RecipeIngredient: Identifiable, Hashable, Codable {
    let id: UUID
    var name: String
    var quantity: String
    var unit: String

    init(id: UUID = UUID(), name: String, quantity: String, unit: String) {
        self.id = id
        self.name = name
        self.quantity = quantity
        self.unit = unit
    }
}

struct Recipe: Identifiable, Hashable, Codable {
    let id: UUID
    var title: String
    var ingredients: [RecipeIngredient]
    var instructions: String

    init(id: UUID = UUID(), title: String, ingredients: [RecipeIngredient], instructions: String) {
        self.id = id
        self.title = title
        self.ingredients = ingredients
        self.instructions = instructions
    }
}

struct RecipesView: View {
    @EnvironmentObject var inventoryModel: InventoryModel
    @State private var recipes: [Recipe] = []
    @State private var searchText = ""
    @State private var showAddPopup = false
    @State private var showFilterPopup = false
    @State private var ingredients: [Ingredient] = []
    
    private let storageKey = "storedRecipes"
    private let ingredientStorageKey = "storedIngredients"

    init() {
        if let data = UserDefaults.standard.data(forKey: ingredientStorageKey),
           let decoded = try? JSONDecoder().decode([Ingredient].self, from: data) {
            _ingredients = State(initialValue: decoded)
        }

        if let data = UserDefaults.standard.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode([Recipe].self, from: data) {
            _recipes = State(initialValue: decoded)
        }
    }

    var body: some View {
        NavigationView {
            mainContent
                .background(backgroundGradient)
                .toolbar { navigationToolbar }
                .searchable(text: $searchText)
                .overlay(addPopupOverlay)
                .overlay(filterPopupOverlay)
        }
    }

    // MARK: - Main Content
    private var mainContent: some View {
        VStack {
            if recipes.isEmpty {
                emptyStateView
            } else {
                recipeListView
            }

            bottomBar
        }
        .padding(.top)
    }

    // MARK: - Gradient
    private var backgroundGradient: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color("LightGreen"), Color("Background")]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }

    // MARK: - Toolbar
    private var navigationToolbar: some ToolbarContent {
        Group {
            ToolbarItem(placement: .navigationBarLeading) {
                Text("Oppskrifter")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(Color("PrimaryGreen"))
                    .fontDesign(.rounded)
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    withAnimation(.spring()) {
                        showFilterPopup.toggle()
                    }
                } label: {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                        .imageScale(.large)
                        .foregroundColor(Color("PrimaryGreen"))
                }
            }
        }
    }

    // MARK: - Popups
    private var addPopupOverlay: some View {
        Group {
            if showAddPopup {
                ZStack {
                    Color.black.opacity(0.6)
                        .ignoresSafeArea()
                        .transition(.opacity)
                        .onTapGesture {
                            withAnimation(.easeOut(duration: 0.25)) {
                                showAddPopup = false
                            }
                        }

                    AddRecipePopupView(
                        onClose: {
                            withAnimation(.easeOut(duration: 0.25)) {
                                showAddPopup = false
                            }
                        },
                        onSave: { recipe in
                            withAnimation {
                                recipes.append(recipe)
                                saveRecipes()
                            }
                        }
                    )
                    .transition(.scale.combined(with: .opacity))
                }
            }
        }
    }

    private var filterPopupOverlay: some View {
        Group {
            if showFilterPopup {
                ZStack {
                    Color.black.opacity(0.6)
                        .ignoresSafeArea()
                        .transition(.opacity)
                        .onTapGesture {
                            withAnimation(.easeOut(duration: 0.25)) {
                                showFilterPopup = false
                            }
                        }

                    RecipeFilterPopupView(onClose: {
                        withAnimation(.easeOut(duration: 0.25)) {
                            showFilterPopup = false
                        }
                    })
                    .transition(.scale.combined(with: .opacity))
                }
            }
        }
    }

    // MARK: - Empty State
    private var emptyStateView: some View {
        VStack {
            Spacer()
            VStack(spacing: 12) {
                Image(systemName: "book.closed")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.gray)

                Text("Ingen oppskrifter")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .fontDesign(.rounded)

                Text("Legg til dine egne oppskrifter her!")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .fontDesign(.rounded)
            }
            Spacer()
        }
    }

    // MARK: - Recipe List Placeholder
    private var recipeListView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Oppskrifter")
                    .font(.headline)
                    .foregroundColor(Color("DeepGreen"))
                    .padding(.horizontal)
                    .fontDesign(.rounded)

                ForEach(recipes.indices, id: \.self) { index in
                    NavigationLink(
                        destination: RecipeDetailView(
                            recipe: $recipes[index],
                            onDelete: {
                                withAnimation {
                                    recipes.remove(at: index)
                                    saveRecipes()
                                }
                            }
                        )
                    ) {
                        VStack(alignment: .leading, spacing: 8) {
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color("GreenCard"))
                                .frame(height: 120)
                                .overlay(
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(recipes[index].title)
                                            .font(.headline)
                                            .foregroundColor(Color("PrimaryGreen"))
                                            .fontDesign(.rounded)

                                        Text("\(recipes[index].ingredients.count) ingredienser")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                            .fontDesign(.rounded)
                                    }
                                    .padding(),
                                    alignment: .bottomLeading
                                )
                                .padding(.horizontal)
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                }

                Spacer(minLength: 50)
            }
            .padding(.top)
        }
    }

    // MARK: - Bottom Bar
    private var bottomBar: some View {
        VStack(spacing: 8) {
            Text("Du har \(recipes.count) oppskrift\(recipes.count == 1 ? "" : "er")")
                .font(.footnote)
                .foregroundColor(.gray)
                .fontDesign(.rounded)

            Button(action: {
                withAnimation(.spring()) {
                    showAddPopup.toggle()
                }
            }) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Legg til oppskrift")
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color("PrimaryGreen"))
                .foregroundColor(.white)
                .cornerRadius(16)
                .padding(.horizontal)
                .font(.headline)
                .fontDesign(.rounded)
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
            }
        }
        .padding(.bottom, 12)
    }
    
    private func saveRecipes() {
        if let data = try? JSONEncoder().encode(recipes) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }
}

#Preview {
    RecipesView()
        .environmentObject(InventoryModel())
}
