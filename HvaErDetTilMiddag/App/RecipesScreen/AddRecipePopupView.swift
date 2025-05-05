//
//  AddRecipePopupView.swift
//  HvaErDetTilMiddag
//
//  Created by Marius Bringsvor Rusten on 05/05/2025.
//


import SwiftUI

struct RecipeIngredient: Identifiable, Hashable {
    let id = UUID()
    var name: String
    var quantity: String
    var unit: String
}

private let units = ["g", "kg", "dl", "l", "ts", "ss", "pk", "stk"]

struct AddRecipePopupView: View {
    @State private var title: String = ""
    @State private var newIngredientName: String = ""
    @State private var newIngredientQty: String = ""
    @State private var newIngredientUnit: String = "stk"
    @State private var ingredients: [RecipeIngredient] = []
    @State private var instructions: String = ""

    var onClose: () -> Void

    private let units = ["stk", "g", "kg", "ml", "l", "ts", "ss", "pk"]

    var body: some View {
        VStack(spacing: 16) {
            Text("Ny Oppskrift")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(Color("PrimaryGreen"))
                .fontDesign(.rounded)

            TextField("Navn på oppskrift", text: $title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .fontDesign(.rounded)

            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 8) {
                    TextField("Ingrediens", text: $newIngredientName)
                        .fontDesign(.rounded)
                        .frame(minWidth: 80)

                    TextField("Mengde", text: $newIngredientQty)
                        .keyboardType(.decimalPad)
                        .frame(width: 60)
                        .fontDesign(.rounded)

                    Picker("", selection: $newIngredientUnit) {
                        ForEach(units, id: \.self) { unit in
                            Text(unit)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .frame(width: 60)
                    .accentColor(Color("PrimaryGreen"))

                    Button(action: {
                        let trimmed = newIngredientName.trimmingCharacters(in: .whitespaces)
                        guard !trimmed.isEmpty else { return }

                        let amount = newIngredientQty.isEmpty ? "1" : newIngredientQty
                        ingredients.append(RecipeIngredient(name: trimmed, quantity: amount, unit: newIngredientUnit))
                        newIngredientName = ""
                        newIngredientQty = ""
                        newIngredientUnit = "stk"
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(Color("PrimaryGreen"))
                            .font(.title2)
                    }
                }

                if ingredients.isEmpty {
                    Text("Ingen ingredienser lagt til enda")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .fontDesign(.rounded)
                } else {
                    ForEach(ingredients) { ingredient in
                        HStack {
                            Text("\(ingredient.name) - \(ingredient.quantity) \(ingredient.unit)")
                                .fontDesign(.rounded)

                            Spacer()

                            Button(action: {
                                ingredients.removeAll { $0.id == ingredient.id }
                            }) {
                                Image(systemName: "minus.circle")
                                    .foregroundColor(.red)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
            )

            VStack(alignment: .leading, spacing: 4) {
                Text("Fremgangsmåte")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .fontDesign(.rounded)

                TextEditor(text: $instructions)
                    .frame(height: 100)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3)))
                    .background(Color.white)
                    .cornerRadius(8)
                    .fontDesign(.rounded)
            }

            HStack {
                Button("Avbryt") {
                    onClose()
                }
                .foregroundColor(.red)
                .fontDesign(.rounded)

                Spacer()

                Button("Lagre") {
                    // TODO: Save to recipes list
                    onClose()
                }
                .foregroundColor(Color("PrimaryGreen"))
                .fontWeight(.bold)
                .fontDesign(.rounded)
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color("GreenCard"))
                .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 5)
        )
        .padding(.horizontal, 24)
    }
}
