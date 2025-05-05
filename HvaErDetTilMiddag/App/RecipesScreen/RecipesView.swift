//
//  RecipesView.swift
//  HvaErDetTilMiddag
//
//  Created by Marius Bringsvor Rusten on 22/04/2025.
//

import SwiftUI

struct RecipesView: View {
    @State private var searchText = ""
    @State private var showFilterPopup = false
    @State private var showAddRecipePopup = false

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                ScrollView {
                    recipeListContent
                }

                addRecipeButton
                    .padding(.bottom, 12)
            }
            .background(backgroundGradient)
            .navigationTitle("")
            .toolbar { topBar }
            .searchable(text: $searchText, prompt: "Søk etter oppskrift")
            .overlay(filterPopupOverlay)
            .overlay(
                Group {
                    if showFilterPopup {
                        filterPopupOverlay
                    }

                    if showAddRecipePopup {
                        Color.black.opacity(0.4)
                            .ignoresSafeArea()
                            .onTapGesture {
                                withAnimation(.easeOut(duration: 0.25)) {
                                    showAddRecipePopup = false
                                }
                            }

                        AddRecipePopupView(onClose: {
                            withAnimation(.easeOut(duration: 0.25)) {
                                showAddRecipePopup = false
                            }
                        })
                        .transition(.scale.combined(with: .opacity))
                    }
                }
            )
        }
    }
    
    private var addRecipeButton: some View {
        Button(action: {
            withAnimation(.spring()) {
                showAddRecipePopup = true
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
    
    private var recipeListContent: some View {
        VStack(spacing: 16) {
            Text("Oppskrifter")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(Color("PrimaryGreen"))
                .fontDesign(.rounded)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)

            if filteredRecipes.isEmpty {
                emptyState
            } else {
                ForEach(filteredRecipes, id: \.self) { name in
                    RecipeCardPlaceholder(name: name)
                }
            }

            Spacer(minLength: 40)
        }
        .padding(.top)
    }
    
    private var topBar: some ToolbarContent {
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
    
    private var backgroundGradient: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color("LightGreen"), Color("Background")]),
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
    
    private var filterPopupOverlay: some View {
        Group {
            if showFilterPopup {
                ZStack {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
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

    private var filteredRecipes: [String] {
        let all = ["Pasta med tomatsaus", "Omelett", "Grønnsakssuppe", "Fruktsalat", "Kyllingwok"]
        if searchText.isEmpty {
            return all
        } else {
            return all.filter { $0.lowercased().contains(searchText.lowercased()) }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "book.closed")
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .foregroundColor(Color("TextPrimary"))

            Text("Ingen forslag enda")
                .font(.headline)
                .foregroundColor(.gray)
                .fontDesign(.rounded)

            Text("Legg til varer i skapet ditt for å få oppskriftforslag!")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .fontDesign(.rounded)
                .padding(.horizontal, 32)
        }
        .padding(.top, 40)
    }
}

// Dynamic version
struct RecipeCardPlaceholder: View {
    var name: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            RoundedRectangle(cornerRadius: 12)
                .fill(Color("GreenCard"))
                .frame(height: 140)
                .overlay(
                    Text(name)
                        .foregroundColor(Color("PrimaryGreen"))
                        .font(.headline)
                        .fontDesign(.rounded)
                        .padding(),
                    alignment: .bottomLeading
                )

            Text("Basert på varene du har")
                .font(.caption)
                .foregroundColor(Color("PrimaryGreen"))
                .fontDesign(.rounded)
                .padding(.leading, 8)
        }
        .padding(.horizontal)
    }
}

#Preview {
    RecipesView()
}
