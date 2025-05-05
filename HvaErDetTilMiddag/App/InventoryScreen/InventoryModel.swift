//
//  InventoryModel.swift
//  HvaErDetTilMiddag
//
//  Created by Marius Bringsvor Rusten on 05/05/2025.
//


import SwiftUI

class InventoryModel: ObservableObject {
    @Published var ingredients: [Ingredient] = []

    private let storageKey = "storedIngredients"

    init() {
        loadIngredients()
    }

    func loadIngredients() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode([Ingredient].self, from: data) {
            self.ingredients = decoded
        }
    }

    func saveIngredients() {
        if let data = try? JSONEncoder().encode(ingredients) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }

    func delete(_ ingredient: Ingredient) {
        ingredients.removeAll { $0.id == ingredient.id }
        saveIngredients()
    }

    func update(_ newList: [Ingredient]) {
        ingredients = newList
        saveIngredients()
    }

    func add(_ newIngredient: Ingredient) {
        ingredients.append(newIngredient)
        saveIngredients()
    }
}