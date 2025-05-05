//
//  AddIngredientPopupView.swift
//  HvaErDetTilMiddag
//
//  Created by Marius Bringsvor Rusten on 04/05/2025.
//

import SwiftUI

struct AddIngredientPopupView: View {
    @Binding var ingredients: [Ingredient]
    var onSave: () -> Void
    var onClose: () -> Void
    var editingIngredient: Ingredient?

    @State private var name: String
    @State private var quantity: String
    @State private var unit: String
    @State private var category: String
    @State private var expirationDate: Date
    @State private var notes: String

    let categories = ["Grønnsaker", "Frukt", "Meieri", "Kjøtt", "Ost", "Egg", "Mel", "Pasta" ,"Fisk", "Pålegg", "Bakst", "Annet"]
    let units = ["g", "kg", "ml", "l", "ts", "ss", "pk", "stk", "glass"]

    init(
        ingredients: Binding<[Ingredient]>,
        onSave: @escaping () -> Void,
        onClose: @escaping () -> Void,
        editingIngredient: Ingredient? = nil
    ) {
        _ingredients = ingredients
        self.onSave = onSave
        self.onClose = onClose
        self.editingIngredient = editingIngredient

        _name = State(initialValue: editingIngredient?.name ?? "")
        _quantity = State(initialValue: editingIngredient?.quantity ?? "")
        _unit = State(initialValue: editingIngredient?.unit ?? "g")
        _category = State(initialValue: editingIngredient?.category ?? "Annet")
        _expirationDate = State(initialValue: editingIngredient?.expirationDate ?? Date())
        _notes = State(initialValue: editingIngredient?.notes ?? "")
    }

    var body: some View {
        VStack(spacing: 16) {
            // Header
            HStack {
                Text(editingIngredient != nil ? "Rediger vare" : "Ny vare")
                    .font(.title3)
                    .fontWeight(.bold)
                    .fontDesign(.rounded)
                    .foregroundColor(Color("PrimaryGreen"))

                Spacer()

                Button(action: onClose) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title2)
                        .foregroundColor(.gray)
                }
            }

            Divider()

            // Inputs
            VStack(alignment: .leading, spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Navn")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(Color("DeepGreen"))
                        .fontDesign(.rounded)
                    TextField("Navn på vare", text: $name)
                        .textFieldStyle(.roundedBorder)
                        .fontDesign(.rounded)
                }

                HStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Mengde")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(Color("DeepGreen"))
                            .fontDesign(.rounded)
                        TextField("f.eks. 2", text: $quantity)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.decimalPad)
                            .fontDesign(.rounded)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text("Enhet")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(Color("DeepGreen"))
                            .fontDesign(.rounded)
                        Picker("", selection: $unit) {
                            ForEach(units, id: \.self) { Text($0) }
                        }
                        .pickerStyle(MenuPickerStyle())
                        .accentColor(Color("PrimaryGreen"))
                    }
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("Kategori")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(Color("DeepGreen"))
                        .fontDesign(.rounded)
                    Picker("Kategori", selection: $category) {
                        ForEach(categories, id: \.self) { Text($0) }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .accentColor(Color("PrimaryGreen"))
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("Utløpsdato")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(Color("DeepGreen"))
                        .fontDesign(.rounded)
                    DatePicker("", selection: $expirationDate, displayedComponents: .date)
                        .accentColor(Color("PrimaryGreen"))
                }

                VStack(alignment: .leading, spacing: 4) {
                    Text("Notater")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(Color("DeepGreen"))
                        .fontDesign(.rounded)
                    TextField("F.eks. Åpnet, må brukes raskt", text: $notes)
                        .textFieldStyle(.roundedBorder)
                        .fontDesign(.rounded)
                }
            }

            Divider()

            // Button
            Button(action: saveIngredient) {
                Text(editingIngredient != nil ? "Lagre endringer" : "Legg til vare")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("PrimaryGreen"))
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .fontDesign(.rounded)
                    .fontWeight(.semibold)
            }
        }
        .padding(20)
        .frame(maxWidth: 500)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color("GreenCard"))
                .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 5)
        )
        .padding(.horizontal, 24)
    }

    private func saveIngredient() {
        let trimmedName = name.trimmingCharacters(in: .whitespaces)
        guard !trimmedName.isEmpty else { return }

        let fullQuantity = quantity.isEmpty ? "1" : quantity

        let newIngredient = Ingredient(
            id: editingIngredient?.id ?? UUID(),
            name: trimmedName,
            quantity: fullQuantity,
            unit: unit,
            category: category,
            expirationDate: expirationDate,
            notes: notes.isEmpty ? nil : notes
        )

        if let index = ingredients.firstIndex(where: { $0.id == newIngredient.id }) {
            ingredients[index] = newIngredient
        } else {
            ingredients.append(newIngredient)
        }

        onSave()
        onClose()
    }
}
