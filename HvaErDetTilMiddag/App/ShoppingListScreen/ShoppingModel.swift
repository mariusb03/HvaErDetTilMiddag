//
//  ShoppingModel.swift
//  HvaErDetTilMiddag
//
//  Created by Marius Bringsvor Rusten on 05/05/2025.
//

import SwiftUI

class ShoppingModel: ObservableObject {
    @Published var items: [Ingredient] = []
    
    func add(_ ingredient: Ingredient) {
        if !items.contains(where: {
            $0.name.lowercased() == ingredient.name.lowercased() &&
            $0.unit.lowercased() == ingredient.unit.lowercased()
        }) {
            items.append(ingredient)
        }
    }

    func addMissing(from recipe: Recipe, inventory: [Ingredient]) {
        for ing in recipe.ingredients {
            let matches = inventory.filter {
                $0.name.lowercased() == ing.name.lowercased() &&
                $0.unit.lowercased() == ing.unit.lowercased()
            }

            let totalAvailable = matches.reduce(0.0) { sum, inv in
                sum + (Double(inv.quantity) ?? 0.0)
            }

            let requiredAmount = Double(ing.quantity) ?? 0.0
            let missingAmount = requiredAmount - totalAvailable

            if missingAmount > 0 {
                let missing = Ingredient(
                    name: ing.name,
                    quantity: String(format: "%.2f", missingAmount),
                    unit: ing.unit,
                    category: "", // Optional
                    expirationDate: Date(),
                    notes: "Fra oppskrift"
                )
                add(missing)
            }
        }
    }
    
    func markAsBought(_ ingredient: Ingredient, inventoryModel: InventoryModel) {
        inventoryModel.ingredients.append(ingredient)
        inventoryModel.saveIngredients()
        items.removeAll { $0.id == ingredient.id }
    }
}
