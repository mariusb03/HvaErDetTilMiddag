import SwiftUI

struct AddIngredientPopupView: View {
    @Binding var ingredients: [Ingredient]
    var onSave: () -> Void
    var onClose: () -> Void

    @State private var name = ""
    @State private var quantity = ""
    @State private var unit = "stk"
    @State private var category = "Grønnsaker"
    @State private var expirationDate = Date()

    let categories = ["Grønnsaker", "Frukt", "Meieri", "Kjøtt", "Fisk", "Pålegg", "Bakst", "Annet"]
    let units = ["stk", "g", "kg", "ml", "l", "ts", "ss", "pk"]

    var body: some View {
        VStack(spacing: 20) {
            Text("Legg til vare")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(Color("PrimaryGreen"))
                .fontDesign(.rounded)

            VStack(alignment: .leading, spacing: 14) {
                TextField("Navn", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .fontDesign(.rounded)

                HStack {
                    TextField("Mengde", text: $quantity)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .fontDesign(.rounded)

                    Picker("", selection: $unit) {
                        ForEach(units, id: \.self) { Text($0) }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .accentColor(Color("PrimaryGreen"))
                    .frame(width: 80)
                }

                Picker("Kategori", selection: $category) {
                    ForEach(categories, id: \.self) { Text($0) }
                }
                .pickerStyle(MenuPickerStyle())
                .accentColor(Color("PrimaryGreen"))
                .fontDesign(.rounded)

                DatePicker("Utløpsdato", selection: $expirationDate, displayedComponents: .date)
                    .accentColor(Color("PrimaryGreen"))
                    .fontDesign(.rounded)
            }

            HStack(spacing: 12) {
                Button("Avbryt") {
                    onClose()
                }
                .foregroundColor(.red)
                .fontDesign(.rounded)
                .padding(.horizontal)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity)
                .background(Color.white.opacity(0.2))
                .cornerRadius(10)

                Button("Legg til") {
                    let trimmedName = name.trimmingCharacters(in: .whitespaces)
                    if !trimmedName.isEmpty {
                        let fullQuantity = quantity.isEmpty ? "1" : quantity
                        let newItem = Ingredient(
                            name: trimmedName,
                            quantity: fullQuantity,
                            unit: unit,
                            category: category,
                            expirationDate: expirationDate
                        )
                        ingredients.append(newItem)
                        onSave()
                        onClose()
                    }
                }
                .foregroundColor(.white)
                .fontDesign(.rounded)
                .fontWeight(.semibold)
                .padding(.horizontal)
                .padding(.vertical, 10)
                .frame(maxWidth: .infinity)
                .background(Color("PrimaryGreen"))
                .cornerRadius(10)
            }
        }
        .padding(24)
        .background(
            RoundedRectangle(cornerRadius: 24)
                .fill(Color("GreenCard"))
                .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 5)
        )
        .padding(.horizontal, 24)
    }
}