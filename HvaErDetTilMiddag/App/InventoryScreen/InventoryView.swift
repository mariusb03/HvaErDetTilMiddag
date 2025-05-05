//
//  InventoryView.swift
//  HvaErDetTilMiddag
//
//  Created by Marius Bringsvor Rusten on 22/04/2025.
//

import SwiftUI

struct Ingredient: Identifiable, Hashable, Codable {
    let id: UUID
    var name: String
    var quantity: String
    var unit: String
    var category: String
    var expirationDate: Date
    var notes: String?

    init(id: UUID = UUID(), name: String, quantity: String, unit: String, category: String, expirationDate: Date, notes: String? = nil) {
        self.id = id
        self.name = name
        self.quantity = quantity
        self.unit = unit
        self.category = category
        self.expirationDate = expirationDate
        self.notes = notes
    }
}

struct InventoryView: View {
    @EnvironmentObject var inventoryModel: InventoryModel
    @Namespace private var popupAnimation

    @State private var searchText = ""
    @State private var showAddPopup = false
    @State private var showExpiringSoonOnly = false
    @State private var showFilterPopup = false
    @State private var selectedCategory: String? = nil
    @State private var sortByExpiration = true
    @State private var ingredientBeingEdited: Ingredient? = nil

    var body: some View {
        NavigationView {
            mainContent
                .background(backgroundGradient)
                .navigationTitle("")
                .toolbar { navigationToolbar }
                .searchable(text: $searchText)
                .overlay(addPopupOverlay)
                .overlay(filterPopupOverlay)
        }
    }

    // MARK: - Main Content
    private var mainContent: some View {
        VStack {
            if inventoryModel.ingredients.isEmpty {
                emptyStateView
            } else {
                ingredientListView
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
                Text("Mine varer")
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
            if showAddPopup || ingredientBeingEdited != nil {
                ZStack {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .transition(.opacity)

                    AddIngredientPopupView(
                        ingredients: $inventoryModel.ingredients,
                        onSave: inventoryModel.saveIngredients,
                        onClose: {
                            withAnimation(.easeOut(duration: 0.25)) {
                                showAddPopup = false
                                ingredientBeingEdited = nil
                            }
                        },
                        editingIngredient: ingredientBeingEdited
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
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .transition(.opacity)

                    FilterPopupView(
                        selectedCategory: $selectedCategory,
                        showExpiringSoonOnly: $showExpiringSoonOnly,
                        sortByExpiration: $sortByExpiration,
                        onClose: {
                            withAnimation(.easeOut(duration: 0.25)) {
                                showFilterPopup = false
                            }
                        }
                    )
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
                Image(systemName: "leaf")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.gray)

                Text("Skapene er tomme")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .fontDesign(.rounded)

                Text("Legg til varer du har hjemme!")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .fontDesign(.rounded)
            }
            Spacer()
        }
    }

    // MARK: - Ingredient List
    private var ingredientListView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text("Ingredienser")
                    .font(.headline)
                    .foregroundColor(Color("DeepGreen"))
                    .padding(.horizontal)
                    .fontDesign(.rounded)

                ForEach(filteredIngredients) { item in
                    let daysLeft = Calendar.current.dateComponents([.day], from: Date(), to: item.expirationDate).day ?? 0
                    let isExpired = daysLeft < 0

                    VStack(alignment: .leading, spacing: 8) {
                        HStack(alignment: .top, spacing: 12) {
                            Text(emojiForCategory(item.category))
                                .font(.title2)

                            VStack(alignment: .leading, spacing: 4) {
                                Text(item.name.capitalized)
                                    .font(.headline)
                                    .fontDesign(.rounded)
                                    .foregroundColor(Color("DeepGreen"))
                                    .strikethrough(isExpired, color: .red)

                                HStack(spacing: 6) {
                                    Text("\(item.quantity) \(item.unit)")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)

                                    Text(item.category)
                                        .font(.caption)
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                        .background(Color("FreshLime"))
                                        .clipShape(Capsule())
                                        .foregroundColor(.white)
                                        .fontDesign(.rounded)
                                }

                                Text("Utløper: \(item.expirationDate, formatter: dateFormatter)")
                                    .font(.caption)
                                    .foregroundColor(daysLeft <= 0 ? .red : (daysLeft <= 3 ? Color("HighlightOrange") : .gray))
                                    .fontDesign(.rounded)

                                if let note = item.notes, !note.isEmpty {
                                    Text(note)
                                        .font(.caption2)
                                        .foregroundColor(.gray)
                                        .fontDesign(.rounded)
                                }
                            }

                            Spacer()
                        }

                        Divider().padding(.top, 4)

                        HStack {
                            Spacer()
                            Button {
                                deleteItem(item)
                            } label: {
                                Label("Slett", systemImage: "trash")
                                    .font(.caption)
                                    .foregroundColor(.red)
                            }
                            .buttonStyle(BorderlessButtonStyle())
                        }
                    }
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color("GreenCard"))
                            .shadow(color: Color.black.opacity(0.05), radius: 4, x: 0, y: 2)
                    )
                    .padding(.horizontal)
                    .onTapGesture {
                        withAnimation(.spring()) {
                            ingredientBeingEdited = item
                        }
                    }
                }

                Spacer(minLength: 50)
            }
            .padding(.top)
        }
    }

    // MARK: - Bottom Add Button
    private var bottomBar: some View {
        VStack(spacing: 8) {
            Text("I dine skap: \(inventoryModel.ingredients.count) varer")
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
                    Text("Legg til vare")
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

    // MARK: - Helpers
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }()

    private var filteredIngredients: [Ingredient] {
        var filtered = inventoryModel.ingredients

        if !searchText.isEmpty {
            filtered = filtered.filter {
                $0.name.lowercased().contains(searchText.lowercased())
            }
        }

        if showExpiringSoonOnly {
            let soon = Calendar.current.date(byAdding: .day, value: 3, to: Date())!
            filtered = filtered.filter { $0.expirationDate <= soon }
        }

        if let selectedCategory {
            filtered = filtered.filter {
                $0.category.lowercased() == selectedCategory.lowercased()
            }
        }

        if sortByExpiration {
            filtered.sort { $0.expirationDate < $1.expirationDate }
        } else {
            filtered.sort { $0.name < $1.name }
        }

        return filtered
    }

    private func deleteItem(_ item: Ingredient) {
        inventoryModel.ingredients.removeAll { $0.id == item.id }
        inventoryModel.saveIngredients()
    }

    private func emojiForCategory(_ category: String) -> String {
        let lower = category.lowercased()
        if lower.contains("meieri") || lower.contains("melk") { return "🥛" }
        if lower.contains("bakst") || lower.contains("brød") { return "🍞" }
        if lower.contains("egg") { return "🥚" }
        if lower.contains("ost") { return "🧀" }
        if lower.contains("frukt") { return "🍎" }
        if lower.contains("grønnsak") { return "🥦" }
        if lower.contains("kjøtt") { return "🥩" }
        if lower.contains("fisk") { return "🐟" }
        if lower.contains("pålegg") { return "🥪" }
        if lower.contains("mel") { return "🌾" }
        if lower.contains("pasta") { return "🍝" }
        if lower.contains("") { return "" }
        return "🍴"
    }
}

#Preview {
    InventoryView()
        .environmentObject(InventoryModel()) // ✅ create an instance here
}
